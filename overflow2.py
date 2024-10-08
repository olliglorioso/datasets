import socket
import hmac
import hashlib

usernro = '552210'
target_ip = 'device1.vikaa.fi'
port = 33578  # Ensure this is the correct port number

def generate_hmac(message, key):
    print(message)
    hmac_obj = hmac.new(key, message.encode(), hashlib.sha256)
    return hmac_obj.hexdigest()

def send_msg(commando, secret_key):
    # Create a socket object
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        s.connect((target_ip, port))
        hmac_input = f'ClientCmd|{usernro}|{commando}'
        hmac1 = generate_hmac(hmac_input, secret_key)
        message = f'{usernro};{commando};{hmac1}\n'
        print(secret_key)
        s.sendall(message.encode()) 
        data = s.recv(1024) 
        print(data.decode())
    finally:
        s.close()
        print("Connection closed")

def gen_as(x): 
    return 'a' * x

key = gen_as(20)
send_msg(gen_as(51), f"{key}".encode())

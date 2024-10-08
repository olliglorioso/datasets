import socket
import hmac
import hashlib

usernro = '552210'
target_ip = 'device1.vikaa.fi'
port = 33578
secret_key = b'your_secret_key_here'  # Replace with the actual key

def generate_hmac(message, key):
    hmac_obj = hmac.new(key, message.encode(), hashlib.sha256)
    return hmac_obj.hexdigest()

def send_msg(commando, secret_key):
    # Create a socket object
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        s.connect((target_ip, port))
        hmac_input = f'ClientCmd;{usernro};{commando}'
        hmac1 = generate_hmac(hmac_input, secret_key)
        full_message = f'{usernro};{commando};{hmac1}'
        print(full_message)
        s.sendall(full_message.encode())
        data = s.recv(1024)
        print("Received:", data.decode())
    finally:
        # Always close the socket after the transaction
        s.close()
        print("Connection closed")

# Example usage
send_msg("moi", secret_key)

import socket
import hmac
import hashlib

usernro = '552210'
target_ip = 'device1.vikaa.fi'
port = 33578  # Ensure this is the correct port number

def generate_hmac(message, key):
    """Generate HMAC-SHA256 as a hexadecimal string."""
    hmac_obj = hmac.new(key, message.encode(), hashlib.sha256)
    return hmac_obj.hexdigest()

def send_msg(cmd, hmac1):
    # Create a socket object
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        # Connect to the server
        s.connect((target_ip, port))
        print(f"Connected to {target_ip} on port {port}")

        # Prepare the message and encode it
        message = f'{usernro};{cmd};{hmac1}\n'
        s.sendall(message.encode())  # Encode the message into bytes

        # Receive data from the server
        data = s.recv(1024)  # Receive up to 1024 bytes
        print("Received:", data.decode())  # Decode received bytes to string
    finally:
        # Always close the socket after the transaction
        s.close()
        print("Connection closed")

# Example usage
send_msg("moi", generate_hmac("moi", "koi"))

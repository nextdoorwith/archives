import smtplib
from email.message import Message

HOSTNAME = "smtp.gmail.com"
USERNAME = "sender@gmail.com"
PASSWORD = "aaaa bbbb cccc"
 
message = Message()
message["From"] = "sender@gmail.com"
message["To"] = "receiver1@gmail.com, receiver2@gmail.com"
message["Subject"] = "test_subject"
message.set_payload("test_body")

# SMTPS
server = smtplib.SMTP_SSL(HOSTNAME, 465)

server.login(USERNAME, PASSWORD)
server.send_message(message)
server.quit()

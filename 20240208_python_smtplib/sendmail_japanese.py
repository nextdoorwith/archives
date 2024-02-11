import smtplib
from email.header import Header
from email.message import Message
from email.utils import formataddr

HOSTNAME = "smtp.gmail.com"
USERNAME = "sender@gmail.com"
PASSWORD = "aaaa bbbb cccc"

tolist = [
    ("試験宛先1", "receiver1@gmail.com"),
    ("試験宛先2", "receiver2@gmail.com")
]
message = Message()
message.set_type("text/plain"); message.set_charset("utf-8")
message["From"] = formataddr(("試験送信者", "sender@gmail.com"))
message["To"] = ", ".join([formataddr(e) for e in tolist])
message["Subject"] = "試験件名"
message.set_payload("試験本文".encode())

server = smtplib.SMTP(HOSTNAME, 587)
server.starttls()
server.login(USERNAME, PASSWORD)
server.send_message(message)
server.quit()

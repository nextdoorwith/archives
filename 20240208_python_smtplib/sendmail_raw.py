import smtplib

HOSTNAME = "smtp.gmail.com"
USERNAME = "sender@gmail.com"
PASSWORD = "aaaa bbbb cccc"
 
from_addr = "sender@gmail.com"
to_addrs = "receiver1@gmail.com, receiver2@gmail.com"
raw_msg = (
    f"From: {from_addr}\r\n"
    f"To: {to_addrs}\r\n"
    f"Subject: test_subject\r\n"
    f"\r\n"
    f"test_body"
)
 
server = smtplib.SMTP(HOSTNAME, 587)
server.starttls()
server.login(USERNAME, PASSWORD)
server.sendmail(from_addr, to_addrs, raw_msg)
server.quit()
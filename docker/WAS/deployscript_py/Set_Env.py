import subprocess
import json
import os
import datetime
import sys
import atexit

# Get environment variable input from client
project_name = input("Project Name을 입력하세요 : ")
db_url = input("DB URL을 입력하세요 : ")
db_username = input("DB UserName을 입력하세요 : ")
db_password = input("DB Password를 입력하세요 : ")
host_port = input("Host Port를 입력하세요 : ")
container_port = input("Container Port")
daemon = input("Daemon Option On / Off 을 선택해주세요 (On / Off)")

# Directory Checking
# ex) pwd == /home/ubuntu/dev/{project_name}/deploy_scripts
pwd = "pwd"
result = subprocess.run(pwd.split(" "), stdout=subprocess.DEVNULL, text=True)


# class Logger:
#     STDOUT_LOG = "./" / "out.log"
#     STDOUT_LOG_F = None
#     STDERR_LOG = "./" / "err.log"
#     STDERR_LOG_F = None

#     @classmethod
#     def close_logs(cls):
#         if cls.STDOUT_LOG_F:
#             cls.STDOUT_LOG_F.close()

#         if cls.STDERR_LOG_F:
#             cls.STDERR_LOG_F.close()

#     @classmethod
#     def setup_log_dir(cls):
#         """
#         Create the LOG_DIR path and STD(OUT|ERR)_LOG files.
#         """
#         cls.STDOUT_LOG.touch(exist_ok=True)
#         cls.STDERR_LOG.touch(exist_ok=True)

#         cls.STDOUT_LOG_F = open(cls.STDOUT_LOG, mode="a")
#         cls.STDERR_LOG_F = open(cls.STDERR_LOG, mode="a")

#         atexit.register(cls.close_logs)

#     @classmethod
#     def print_out(cls, msg: str, end=os.linesep, print_=True):
#         if cls.STDOUT_LOG_F:
#             cls.STDOUT_LOG_F.write(msg + end)
#             cls.STDOUT_LOG_F.flush()
#         if print_:
#             print(msg, end=end, file=sys.stdout)

#     @classmethod
#     def print_err(cls, msg: str, end=os.linesep, print_=True):
#         if cls.STDERR_LOG_F:
#             cls.STDERR_LOG_F.write(msg + end)
#             cls.STDERR_LOG_F.flush()
#         if print_:
#             print(msg, end=end, file=sys.stderr)


# print_out = Logger.print_out
# print_err = Logger.print_err


class Check_Git_Ignore:
    def check_Git_Ignore() -> bool:
        """
        Git ignore에 '.env.json' 이 포함되어있나 Check
        없다면 추가 있다면 Pass
        """

        cmd = f"cat {pwd}/.gitignore | grep .env.json"
        result = subprocess.run(cmd.split(" "), stdout=subprocess.DEVNULL, text=True)

        if result.stdout == False:
            return False
        else:
            return True

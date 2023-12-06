#!/usr/bin/env python3

import argparse
import subprocess
import threading


# Dictionaries from SecLists
directories_list = "/usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt"
files_list = "/usr/share/seclists/Discovery/Web-Content/raft-medium-files.txt"

# Output files
directories_file = "ffuf_dirs.txt"
files_file = "ffuf_files.txt"
out_file = "ffuf_output.txt"

# Template for constructing ffuf command
ffuf_template = "ffuf -w {} -u {} | tee {}"


# Class for running ffuf commands
class CmdThread(threading.Thread):
    def __init__(self, command):
        threading.Thread.__init__(self)
        self._command = command

    def run(self):
        subprocess.Popen(self._command, shell=True, stdout=subprocess.PIPE).stdout.read()


def get_args():
    parser = argparse.ArgumentParser("Web App Fuzzer")
    parser.add_argument(
        "--target", "-t",
        help="Target URL for fuzzing (e.g. http://domain.tld/)",
        required=True
    )
    args = parser.parse_args()
    return args.target


def main():
    # Get the IP/host
    host = get_args()

    # Construct ffuf commands
    if host.endswith("/"):
        host += "FUZZ"
    else:
        host += "/FUZZ"

    ffuf_command_directories = ffuf_template.format(directories_list, host, directories_file)
    ffuf_command_files = ffuf_template.format(files_list, host, files_file)

    # Create threads - ffuf
    directories_thread = CmdThread(ffuf_command_directories)
    files_thread = CmdThread(ffuf_command_files)

    # Start threads - ffuf
    directories_thread.start()
    files_thread.start()

    # Wait for current threads to finish
    for thread in [directories_thread, files_thread]:
        thread.join()

    # Combine output files
    combination_command = f"cat {directories_file} {files_file} > {out_file} && rm {directories_file} {files_file}"
    subprocess.Popen(combination_command, shell=True, stdout=subprocess.PIPE).stdout.read()


if __name__ == "__main__":
    main()


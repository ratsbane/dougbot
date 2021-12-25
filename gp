#!/usr/bin/python3

from __future__ import print_function
from inputs import get_gamepad
import RPi.GPIO as GPIO          
import time
import json
import pickle
import io
from espeak import espeak


# Set up hardware

in1 = 24
in2 = 23
en = 25

e_in1 = 14  # yellow
e_in2 = 18  # blue
e_en = 15   # green

base_in1=7
base_in2=8
base_en = 1

pump_in1=16
pump_in2=20
pump_en = 21

temp1=1

GPIO.setmode(GPIO.BCM)

# shoulder
GPIO.setup(in1,GPIO.OUT)
GPIO.setup(in2,GPIO.OUT)
GPIO.setup(en,GPIO.OUT)
GPIO.output(in1,GPIO.LOW)
GPIO.output(in2,GPIO.LOW)

# elbow
GPIO.setup(e_in1, GPIO.OUT)
GPIO.setup(e_in2, GPIO.OUT)
GPIO.setup(e_en, GPIO.OUT )
GPIO.output(e_in1,GPIO.LOW)
GPIO.output(e_in2,GPIO.LOW)

# base
GPIO.setup(base_in1, GPIO.OUT)
GPIO.setup(base_in2, GPIO.OUT)
GPIO.setup(base_en, GPIO.OUT )
GPIO.output(base_in1,GPIO.LOW)
GPIO.output(base_in2,GPIO.LOW)


GPIO.setup(pump_in1, GPIO.OUT)
GPIO.setup(pump_in2, GPIO.OUT)
GPIO.setup(pump_en, GPIO.OUT )
GPIO.output(pump_in1,GPIO.LOW)
GPIO.output(pump_in2,GPIO.LOW)


p=GPIO.PWM(en,1000)
e_p=GPIO.PWM(e_en,1000)
base_p=GPIO.PWM(base_en,1000)
pump_p=GPIO.PWM(pump_en,1000)

p.start(100)
e_p.start(100)
base_p.start(100)
pump_p.start(100)

# p.ChangeDutyCycle(25)


print("\n")
print("DOUGBOT 1")
espeak.synth('Dougbot one is starting')
print("a s d - shoulder")
print("j k l - elbow")
print("z x c - base")
print("i o p - pump")
print("\n")    



def process_command (x):
    if x=='a':
        print("shoulder retract")
        espeak.synth('shoulder retracting')
        GPIO.output(in1,GPIO.LOW)
        GPIO.output(in2,GPIO.HIGH)

    elif x=='s':
        print("shoulder stop")
        espeak.synth('shoulder stop')
        GPIO.output(in1,GPIO.LOW)
        GPIO.output(in2,GPIO.LOW)

    elif x=='d':
        print("shoulder extend")
        espeak.synth('shoulder extend')
        GPIO.output(in1,GPIO.HIGH)
        GPIO.output(in2,GPIO.LOW)

    elif x == 'j':
        print('elbow extend')
        GPIO.output( e_in1, GPIO.LOW)
        GPIO.output( e_in2, GPIO.HIGH)

    elif x == 'k':
        print('elbow stop')
        GPIO.output( e_in1, GPIO.LOW)
        GPIO.output( e_in2, GPIO.LOW)

    elif x == 'l':
        print('elbow retract')
        GPIO.output( e_in1, GPIO.HIGH)
        GPIO.output( e_in2, GPIO.LOW)

    elif x == 'z':
        print('base rotate left')
        GPIO.output( base_in1, GPIO.LOW)
        GPIO.output( base_in2, GPIO.HIGH)

    elif x == 'x':
        print('base stop')
        GPIO.output( base_in1, GPIO.LOW)
        GPIO.output( base_in2, GPIO.LOW)

    elif x == 'c':
        print('base rotate right')
        GPIO.output( base_in1, GPIO.HIGH)
        GPIO.output( base_in2, GPIO.LOW)

    elif x == 'i':
        print('pump in')
        GPIO.output( pump_in1, GPIO.LOW)
        GPIO.output( pump_in2, GPIO.HIGH)

    elif x == 'o':
        print('pump stop')
        GPIO.output( pump_in1, GPIO.LOW)
        GPIO.output( pump_in2, GPIO.LOW)

    elif x == 'p':
        print('pump out')
        GPIO.output( pump_in1, GPIO.HIGH)
        GPIO.output( pump_in2, GPIO.LOW)

    
    elif x=='e' or x == 'q':
        GPIO.cleanup()
        print("GPIO Clean up")
        return 1
   
    elif x==' ':
        GPIO.output(in1,GPIO.LOW)
        GPIO.output(in2,GPIO.LOW)
        GPIO.output( e_in1, GPIO.LOW)
        GPIO.output( e_in2, GPIO.LOW)
        GPIO.output( base_in1, GPIO.LOW)
        GPIO.output( base_in2, GPIO.LOW)
        GPIO.output( pump_in1, GPIO.LOW)
        GPIO.output( pump_in2, GPIO.LOW)
        print("all stop")

    else:
        print("I'm afraid I can't do that, Dave.")


while(0):

    raw = raw_input()
    
    for x in raw:
        c = process_command(x)
        print('c is '+str(c))
        if ( c==1 ):
            break

    if c==1: break






def shoulder(d):

    duty_cycle = 33*abs(d)
    if duty_cycle<0: duty_cycle=0
    if duty_cycle>100: duty_cycle=100

    p.ChangeDutyCycle(duty_cycle)
    print('d is '+str(d))
    if d<0:
        print("shoulder retract")
        GPIO.output(in1,GPIO.LOW)
        GPIO.output(in2,GPIO.HIGH)

    elif d==0:
        print("shoulder stop")
        GPIO.output(in1,GPIO.LOW)
        GPIO.output(in2,GPIO.LOW)

    elif d>0:
        print("shoulder extend")
        GPIO.output(in1,GPIO.HIGH)
        GPIO.output(in2,GPIO.LOW)


def elbow(d):
    duty_cycle = 33*abs(d)
    if duty_cycle<0: duty_cycle=0
    if duty_cycle>100: duty_cycle=100

    p.ChangeDutyCycle(duty_cycle)

    if  d<0:
        print('elbow extend')
        GPIO.output( e_in1, GPIO.LOW)
        GPIO.output( e_in2, GPIO.HIGH)

    elif d== 0:
        print('elbow stop')
        GPIO.output( e_in1, GPIO.LOW)
        GPIO.output( e_in2, GPIO.LOW)

    elif d >0:
        print('elbow retract')
        GPIO.output( e_in1, GPIO.HIGH)
        GPIO.output( e_in2, GPIO.LOW)



def base(d):
    duty_cycle = 33*abs(d)
    if duty_cycle<0: duty_cycle=0
    if duty_cycle>100: duty_cycle=100

    p.ChangeDutyCycle(duty_cycle)

    if d<0:
        print('base rotate left')
        GPIO.output( base_in1, GPIO.LOW)
        GPIO.output( base_in2, GPIO.HIGH)

    elif d == 0:
        print('base stop')
        GPIO.output( base_in1, GPIO.LOW)
        GPIO.output( base_in2, GPIO.LOW)

    elif d>0:
        print('base rotate right')
        GPIO.output( base_in1, GPIO.HIGH)
        GPIO.output( base_in2, GPIO.LOW)


def replay_steps(steps):
    pickle.dump(steps, open("stored_actions", "wb"))
    print("replaying steps "+json.dumps( steps ) )
    prevtime = steps[0][0]
    for step in steps:
        if step[1] == 'shoulder': shoulder(step[2])
        elif step[1] == 'elbow': elbow(step[2])
        elif step[1] == 'base': base(step[2])
        time.sleep( (step[0]-prevtime)/1000000000 )
        prevtime=step[0]
    shoulder(0)
    elbow(0)
    base(0)


def main():

    prev_x = 0
    prev_y = 0
    prev_rx = 0
    keep_going = 1
    learning = 0
    steps = []
    stored_steps = {}
    while keep_going:
        events = get_gamepad()
        for event in events:
            if event.code == 'BTN_MODE':
                if event.state == 1:
                    if not learning:
                        print("Learning started.  Press again to cancel or press A, B, X, or Y to store")
                        learning = 1
                        steps = []  # clear out the array of learned steps
                    else:
                        print("Learning cancelled.")
                        learning = 0
                        steps = []
            if (event.code == 'BTN_NORTH' or event.code == 'BTN_EAST' or event.code == 'BTN_SOUTH' or event.code == 'BTN_WEST') and event.state == 1:
                if learning:
                    # stop learning and copy steps to stored_steps[event.code]
                    print("Learning stopped.  Steps saved in "+str(event.code))
                    stored_steps[event.code] = steps
                    learning = 0
                    steps = []
                elif event.code in stored_steps:
                    replay_steps(stored_steps[event.code])
                
            if event.code=='ABS_HAT0X' or event.code=='ABS_HAT0Y':
                print(event.code, event.state)
            if event.code == 'ABS_X' and int(event.state/8192) != prev_x:
                if abs(event.state)<4096: state=0
                else: state=int(event.state/8192)
                prev_x = state
                #print("x is "+str(prev_x))
                steps.append( [ time.monotonic_ns(), 'shoulder', prev_x ] )
                shoulder(prev_x)
            if event.code == 'ABS_Y' and int(event.state/8192) != prev_y:
                if abs(event.state)<8192: state=0
                else: state=int(event.state/8192)
                prev_y = state
                #print("y is "+str(prev_y))
                steps.append( [ time.monotonic_ns(), 'elbow', prev_y ] )
                elbow(prev_y)
            if event.code == 'ABS_RX' and int(event.state/8192) != prev_rx:
                if abs(event.state)<8192: state=0
                else: state=int(event.state/8192)
                prev_rx = state
                #print("rx is "+str(prev_rx))
                steps.append( [ time.monotonic_ns(), 'base', prev_rx ] )
                base(prev_rx)



if __name__ == "__main__":
    main()


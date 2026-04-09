import RPi.GPIO as GPIO
from config import GPIO_PIN


class LightSensor:
    def __init__(self):
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(GPIO_PIN, GPIO.IN)

    def read(self):
        """
        LM393 DO 핀 읽기
        반환값: 'on' (밝음 - LED 켜짐) / 'off' (어두움 - LED 꺼짐)
        """
        value = GPIO.input(GPIO_PIN)
        return "on" if value == GPIO.HIGH else "off"

    def cleanup(self):
        GPIO.cleanup()

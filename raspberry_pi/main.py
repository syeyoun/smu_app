import time
from sensor import LightSensor
from firebase_client import FirebaseClient
from config import POLL_INTERVAL


def main():
    sensor = LightSensor()
    firebase = FirebaseClient()

    last_status = None
    print("동아리방 상태 감지 시작...")

    try:
        while True:
            status = sensor.read()

            # 상태가 바뀔 때만 Firebase 업데이트 (불필요한 쓰기 방지)
            if status != last_status:
                firebase.update_status(status)
                last_status = status

            time.sleep(POLL_INTERVAL)

    except KeyboardInterrupt:
        print("종료")
    finally:
        sensor.cleanup()


if __name__ == "__main__":
    main()

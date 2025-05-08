from flask import Flask, request, jsonify
from google.oauth2 import service_account
import google.auth.transport.requests
import requests
import json
import time
import threading

# Firebase Admin SDK imports
import firebase_admin
from firebase_admin import credentials as admin_credentials, firestore

# ====== Cấu hình ======
SERVICE_ACCOUNT_FILE = 'D:/HTML dev/DA_LTW/Mobile-Programing/server/key/services_account.json'
SCOPES = ['https://www.googleapis.com/auth/firebase.messaging']

# Khởi tạo Firebase Admin để ghi ngrok URL
admin_cred = admin_credentials.Certificate(SERVICE_ACCOUNT_FILE)
firebase_admin.initialize_app(admin_cred)
db = firestore.client()

# Tạo credentials từ service account để gửi FCM
driver_credentials = service_account.Credentials.from_service_account_file(
    SERVICE_ACCOUNT_FILE,
    scopes=SCOPES
)
PROJECT_ID = driver_credentials.project_id

app = Flask(__name__)

# ====== Hàm lấy Access Token ======
def get_access_token():
    try:
        request_adapter = google.auth.transport.requests.Request()
        driver_credentials.refresh(request_adapter)
        return driver_credentials.token
    except Exception as e:
        app.logger.error(f"Error getting access token: {e}")
        return None

# ====== Đọc ngrok URL và cập nhật Firestore ======
def update_ngrok_url():
    try:
        # Lấy ngrok tunnels
        resp = requests.get('http://127.0.0.1:4040/api/tunnels')
        data = resp.json()
        for tunnel in data.get('tunnels', []):
            if tunnel.get('proto') == 'https':
                public_url = tunnel.get('public_url')
                # Lưu vào Firestore
                db.collection('config').document('server').set({'url': public_url})
                app.logger.info(f"Updated ngrok URL in Firestore: {public_url}")
                break
    except Exception as e:
        app.logger.error(f"Failed to update ngrok URL: {e}")

# Chạy update_ngrok_url sau khi bắt đầu
def schedule_ngrok_update():
    # Đợi ngrok khởi động
    time.sleep(2)
    update_ngrok_url()
    # Lặp định kỳ mỗi 5 phút
    while True:
        time.sleep(300)
        update_ngrok_url()

# ====== API gửi thông báo ======
@app.route('/send-message-notification', methods=['POST'])
def send_notification():
    try:
        data = request.get_json()
        fcm_token = data.get('fcmToken')
        title = data.get('title', 'No title')
        body = data.get('body', 'No body')
        custom_data = data.get('data', {})

        if not fcm_token:
            return jsonify({'success': False, 'error': 'Missing fcmToken'}), 400

        message = {
            'message': {
                'token': fcm_token,
                'notification': {
                    'title': title,
                    'body': body
                },
                'data': custom_data
            }
        }

        access_token = get_access_token()
        if not access_token:
            return jsonify({'success': False, 'error': 'Unable to retrieve access token'}), 500

        headers = {
            'Authorization': f'Bearer {access_token}',
            'Content-Type': 'application/json; UTF-8',
        }

        url = f'https://fcm.googleapis.com/v1/projects/{PROJECT_ID}/messages:send'
        resp = requests.post(url, headers=headers, data=json.dumps(message))

        if resp.status_code == 200:
            return jsonify({'success': True, 'response': resp.json()}), 200
        else:
            return jsonify({'success': False, 'error': resp.text}), resp.status_code

    except Exception as e:
        app.logger.error(f"Unexpected error: {e}")
        return jsonify({'success': False, 'error': str(e)}), 500

if __name__ == '__main__':
    # Chạy ngrok URL updater trong thread riêng
    threading.Thread(target=schedule_ngrok_update, daemon=True).start()
    app.run(port=5000, debug=True)

from fastapi import FastAPI, WebSocket
import uvicorn
import json

app = FastAPI()
clients = []

@app.websocket("/ws/send-sms")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    clients.append(websocket)
    print("✅ New WebSocket connection established")

    try:
        while True:
            await websocket.receive_text()
    except:
        clients.remove(websocket)
        print("❌ WebSocket connection lost")

# This function broadcasts a JSON message to all connected clients
async def broadcast_sms(phone, message):
    data = json.dumps({
        "phone_number": phone,
        "message": message
    })
    print(f"📤 Sending JSON: {data} ({len(clients)} client(s))")
    for client in clients:
        await client.send_text(data)

# Example endpoint to trigger a test SMS
@app.post("/test-send")
async def send_example():
    await broadcast_sms("<phone_number>", "This is a test message!")
    return {"status": "Message sent"}
    
if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
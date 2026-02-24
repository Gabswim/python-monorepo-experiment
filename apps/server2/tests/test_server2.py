from fastapi.testclient import TestClient

from postmodern.server2.run import app


def test_greet():
    client = TestClient(app)
    response = client.get("/greet", params={"name": "World"})
    assert response.status_code == 200
    assert "World" in response.json()["message"]

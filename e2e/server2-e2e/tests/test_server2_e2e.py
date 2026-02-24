import pathlib
import subprocess
import time

import httpx
import pytest

REPO_ROOT = pathlib.Path(__file__).resolve().parents[3]


@pytest.fixture(scope="module")
def server():
    """Start the server2 application on a test port and tear it down after tests."""
    proc = subprocess.Popen(
        ["uv", "run", "uvicorn", "postmodern.server2.run:app", "--port", "8765"],
        cwd=str(REPO_ROOT / "apps" / "server2"),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    # Wait for the server to be ready
    deadline = time.time() + 10
    while time.time() < deadline:
        try:
            httpx.get("http://localhost:8765/docs")
            break
        except httpx.ConnectError:
            time.sleep(0.2)
    else:
        proc.terminate()
        pytest.fail("Server did not start within 10 seconds")  # type: ignore[arg-type]

    yield "http://localhost:8765"

    proc.terminate()
    proc.wait(timeout=5)


def test_greet_returns_message(server):
    """The /greet endpoint should return a greeting containing the given name."""
    response = httpx.get(f"{server}/greet", params={"name": "World"})
    assert response.status_code == 200

    body = response.json()
    assert "message" in body
    assert "World" in body["message"]


def test_greet_requires_name(server):
    """The /greet endpoint should return 422 when the name param is missing."""
    response = httpx.get(f"{server}/greet")
    assert response.status_code == 422

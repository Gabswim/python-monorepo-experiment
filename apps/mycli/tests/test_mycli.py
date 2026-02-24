from contextlib import redirect_stdout
from io import StringIO
from types import SimpleNamespace
from unittest.mock import patch

from postmodern.mycli import cli


def test_main() -> None:
    stdout = StringIO()
    with patch("urllib3.request", return_value=SimpleNamespace(status=200)):
        with redirect_stdout(stdout):
            cli.main()

    assert stdout.getvalue().strip() == "Status: 200"

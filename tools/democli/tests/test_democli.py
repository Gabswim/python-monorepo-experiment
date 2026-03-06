from postmodern.democli import cli


def test_main_outputs(capsys) -> None:
    cli.main()
    captured = capsys.readouterr()
    assert "Hello!" in captured.out

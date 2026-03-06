from postmodern.democli import cli


def test_main_outputs(capsys) -> None:  # type: ignore[no-untyped-def]
    cli.main()
    captured = capsys.readouterr()
    assert "Hello!" in captured.out

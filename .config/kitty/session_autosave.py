import os
import time
from typing import Any

DEFAULT_PATH = os.path.expanduser('~/.config/kitty/startup.kitty-session')
DEBOUNCE_SECONDS = 2.0

_last_write = 0.0


def session_path() -> str:
    return os.environ.get('KITTY_SESSION_AUTOSAVE_PATH') or DEFAULT_PATH


def save_session(boss: Any) -> None:
    global _last_write
    now = time.monotonic()
    if now - _last_write < DEBOUNCE_SECONDS:
        return

    text = '\n'.join(boss.serialize_state_as_session())
    if 'launch' not in text:
        return

    path = session_path()
    tmp = path + '.tmp'
    with open(tmp, 'w') as f:
        f.write(text + '\n')
    if os.path.exists(path):
        os.replace(path, path + '.prev')
    os.replace(tmp, path)
    _last_write = now


def on_quit(boss: Any, window: Any, data: dict[str, Any]) -> None:
    save_session(boss)

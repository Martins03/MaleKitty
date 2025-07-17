@echo off
REM ─────────── Backend ───────────
cd Backend\
call env\Scripts\activate
cd MaleKitty_API
start cmd /k "python -m uvicorn main:app --reload --host 127.0.0.1 --port 8000"
REM ─────────── Frontend ──────────
cd ..\..\FrontEnd\malekitymlaas-new
start cmd /k "npm run serve"
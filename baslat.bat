@echo off
title Döviz Takip - Başlatıcı
echo ================================================
echo   Döviz Kuru Takip Sistemi baslatiliyor...
echo ================================================
echo.

REM 1. Flask uygulamasini ayri bir pencerede baslat
start "Döviz Flask Sunucusu" cmd /k "cd /d %~dp0 && pip install -r requirements.txt && python app.py"

REM Flask'in ayaga kalkmasi icin bekle
timeout /t 4 /nobreak >nul

REM 2. Cloudflare Tunnel'i ayri bir pencerede baslat
echo Cloudflare Tunnel baslatiliyor...
echo.
echo NOT: Asagidaki pencerede cikan "https://....trycloudflare.com"
echo      linkini kopyalayip paylasabilirsin.
echo.
start "Döviz Cloudflare Tunnel" cmd /k "%USERPROFILE%\OneDrive\Desktop\Claudflare\cloudflared.exe tunnel --url http://localhost:5000"

echo.
echo Iki pencere de acildi:
echo   1) Flask Sunucusu    -^> KAPATMA, arka planda calisuyor
echo   2) Cloudflare Tunnel -^> linki buradan alabilirsin
echo.
echo Bu pencereyi kapatabilirsin.
pause

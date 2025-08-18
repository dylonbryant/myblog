---
title: "Automating My Blog Deployment with PowerShell and Shortcuts"
date: 2025-08-18
draft: false
slug: automating-my-blog-deployment-with-powershell-and-shortcuts
tags: ["hugo", "obsidian", "github-pages", "powershell"]
---

Today I set up a simple automation for publishing my Obsidian-based blog. Instead of manually typing out Git commands every time, I now just double-click a desktop shortcut and everything is pushed for me. Here’s a breakdown of what I did step by step.

## 1. The Goal

I wanted a **one-click solution** to publish my notes. The workflow was:

1. Write notes in Obsidian.
    
2. Run a script that commits changes and pushes to GitHub.
    
3. Trigger that script with a desktop shortcut.
    

---

## 2. Creating the Publish Script

I started with a PowerShell script (`publish.ps1`) that automates the Git workflow. It looks like this:

`git add . git commit -m "Publish: $(Get-Date -Format 'yyyy-MM-dd HH:mm')" git push`

This script stages all changes, commits them with a timestamp, and pushes to the remote repository.

---

## 3. Solving Execution Policy Errors

When I tried to run the script, Windows blocked it because script execution is restricted by default:

`File cannot be loaded because running scripts is disabled on this system.`

To get around that without lowering system-wide security, I ran PowerShell with this command:

`powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Dylon\Documents\myblog\publish.ps1"`

This temporarily bypasses the execution policy only for that script.

---

## 4. Creating a Batch File Wrapper

Typing the full command every time isn’t fun. So I created a `.bat` file called `publish.bat` inside my blog folder:

`@echo off powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0publish.ps1"`

This wrapper ensures I can run the script just by double-clicking the batch file.

---

## 5. Adding a Desktop Shortcut

To make it truly **one-click**, I used PowerShell to generate a Windows shortcut (`.lnk`) on my Desktop:

`$Target = "C:\Users\Dylon\Documents\myblog\publish.bat" $Shortcut = "$env:USERPROFILE\Desktop\Publish Blog.lnk" $WScriptShell = New-Object -ComObject WScript.Shell $SC = $WScriptShell.CreateShortcut($Shortcut) $SC.TargetPath = $Target $SC.WorkingDirectory = Split-Path $Target $SC.Save()`

Now I’ve got a **Publish Blog** shortcut sitting on my Desktop. Double-clicking it runs the batch file, which calls the PowerShell script, which commits and pushes my changes.

---

## 6. The Final Workflow

- Write in Obsidian.
    
- Save.
    
- Double-click **Publish Blog** on my Desktop.
    
- My content is live. ✅
    

---

## 7. What I Learned

- PowerShell’s execution policy will block scripts unless you explicitly bypass it.
    
- `.bat` files are still super useful for wrapping commands.
    
- Automating small things like this saves mental energy and makes publishing frictionless.

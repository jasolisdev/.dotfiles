;; Place your private configuration here
(setq
 doom-font (font-spec :family "Source Code Pro" :size 30)
 doom-big-font (font-spec :family "Source Pro" :size 36)
 doom-variable-pitch-font (font-spec :family "Source Code Pro" :size 18)
 doom-theme 'doom-gruvbox

 ;; scroling
 scroll-margin 5
 scroll-preserve-screen-position 1

 ;; Enable copy/paste from clipboard
 select-enable-clipboard t

 ;; always reload file if it changeon disk
 global-auto-revert-mode 1

 show-paren-mode 1

 ;; 4 char and space for line numbers
 linum-format "%4d "

 ;; Indentention
 web-mode-markup-indent-offset 2
 web-mode-code-indent-offset 2
 web-mode-css-indent-offset 2
 js-indent-level 2
 typescript-indent-level 2
 json-reformat:indent-width 2
 css-indent-offset 2
 dart-format-on-save t
 projectile-project-search-path '("~/projects/"))
 ;; +doom-dashboard-banner-file (expand-file-name "logo.png" doom-private-dir))


;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)


;----------------Smooth scroll--------------

; Disable Scroll Bar
;; (scroll-bar-mode -1)

;(setq scroll-step            1
;      scroll-conservatively  10000)

;scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq scroll-margin 1
      scroll-conservatively 0
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01)

;-------------------KEY BINDS--------------------

; Switch between windows alt-w
(define-key global-map "\ew" 'other-window)

; Find file in current window alt-f
(define-key global-map "\ef" 'find-file)
; Find file in other window alt-shift-f
(define-key global-map "\eF" 'find-file-other-window)
; banlance windows
(global-set-key (kbd "C-x b") 'balance-windows)

; go to line alt-g
(define-key global-map "\eg" 'goto-line)

; travel to next/previous erros
(define-key global-map "\en" 'next-error)
(define-key global-map "\eN" 'previous-error)

(define-key global-map "\eo" 'query-replace)

; switch buffer on current focused window alt-b
(global-set-key (read-kbd-macro "\eb")  'ido-switch-buffer)
; switch buffer on other window alt-shift-b
(global-set-key (read-kbd-macro "\eB")  'ido-switch-buffer-other-window)



(load-file "~/.doom.d/emacs-c++.el")

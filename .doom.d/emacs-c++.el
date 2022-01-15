; ~/.emacs.d/elisp/emacs-c++.el

(require 'cc-mode)

; Accepted file extensions and their appropriate modes
(setq auto-mode-alist
      (append
       '(("\\.cpp$"    . c++-mode)
         ("\\.hin$"    . c++-mode)
         ("\\.cin$"    . c++-mode)
         ("\\.inl$"    . c++-mode)
         ("\\.rdc$"    . c++-mode)
         ("\\.h$"    . c++-mode)
         ("\\.c$"   . c++-mode)
         ("\\.cc$"   . c++-mode)
         ("\\.c8$"   . c++-mode)
         ("\\.txt$" . indented-text-mode)
         ("\\.emacs$" . emacs-lisp-mode)
         ("\\.gen$" . gen-mode)
         ("\\.ms$" . fundamental-mode)
         ("\\.m$" . objc-mode)
         ("\\.mm$" . objc-mode)
         ) auto-mode-alist))

; C++ indentation style
(defconst solis-c-style
  '((c-electric-pound-behavior   . nil)
    (c-tab-always-indent         . t)
    (c-comment-only-line-offset  . 0)
    (c-hanging-braces-alist      . ((class-open)
                                    (class-close)
                                    (defun-open)
                                    (defun-close)
                                    (inline-open)
                                    (inline-close)
                                    (brace-list-open)
                                    (brace-list-close)
                                    (brace-list-intro)
                                    (brace-list-entry)
                                    (block-open)
                                    (block-close)
                                    (substatement-open)
                                    (statement-case-open)
                                    (class-open)))
    (c-hanging-colons-alist      . ((inher-intro)
                                    (case-label)
                                    (label)
                                    (access-label)
                                    (access-key)
                                    (member-init-intro)))
    (c-cleanup-list              . (scope-operator
                                    list-close-comma
                                    defun-close-semi))
    (c-offsets-alist             . ((arglist-close         .  c-lineup-arglist)
                                    (label                 . -4)
                                    (access-label          . -4)
                                    (substatement-open     .  0)
                                    (statement-case-intro  .  4)
                                    (statement-block-intro .  c-lineup-for)
                                    (case-label            .  4)
                                    (block-open            .  0)
                                    (inline-open           .  0)
                                    (topmost-intro-cont    .  0)
                                    (knr-argdecl-intro     . -4)
                                    (brace-list-open       .  0)
                                    (brace-list-intro      .  4)))
    (c-echo-syntactic-information-p . t))
    "Solis's C++ Style")

; C++ mode handling
(defun solis-c-hook ()
; Set my style for the current buffer
  (c-add-style "Solis" solis-c-style t)
 
; 4-space tabs
(setq tab-width 4
       indent-tabs-mode nil)

; Additional style stuff
(c-set-offset 'member-init-intro '++)

; No hungry backspace
(c-toggle-auto-hungry-state -1)

; Newline indents, semi-colon doesn't
(define-key c++-mode-map "\C-m" 'newline-and-indent)
(setq c-hanging-semi&comma-criteria '((lambda () 'stop)))

; Handle super-tabbify (TAB completes, shift-TAB actually tabs)
(setq dabbrev-case-replace t)
(setq dabbrev-case-fold-search t)
(setq dabbrev-upcase-means-case-search t)

; Abbrevation expansion
(abbrev-mode 1)
 
(defun solis-header-format ()
   "Format the given file as a header file."
   (interactive)
   (setq BaseFileName (file-name-sans-extension (file-name-nondirectory buffer-file-name)))
   (insert "#ifndef ")
   (push-mark)
   (insert BaseFileName)
   (upcase-region (mark) (point))
   (pop-mark)
   (insert "_H\n")
   (insert "/* ========================================================================\n")
   (insert "   $File: $\n")
   (insert "   $Date: $\n")
   (insert "   $Creator: Jose Solis $\n")
   (insert "   ======================================================================== */\n")
   (insert "\n")
   (insert "#define ")
   (push-mark)
   (insert BaseFileName)
   (upcase-region (mark) (point))
   (pop-mark)
   (insert "_H\n")
   (insert "#endif")
)
  
(defun solis-source-format ()
   "Format the given file as a source file."
   (interactive)
   (setq BaseFileName (file-name-sans-extension (file-name-nondirectory buffer-file-name)))
   (insert "/* ========================================================================\n")
   (insert "   $File: $\n")
   (insert "   $Date: $\n")
   (insert "   $Creator: Jose Solis $\n")
   (insert "   ======================================================================== */\n")
)

(cond ((file-exists-p buffer-file-name) t)
      ((string-match "[.]hin" buffer-file-name) (solis-source-format))
      ((string-match "[.]cin" buffer-file-name) (solis-source-format))
      ((string-match "[.]h" buffer-file-name) (solis-header-format))
      ((string-match "[.]cpp" buffer-file-name) (solis-source-format)))

(defun solis-find-corresponding-file ()
  "Find the file that corresponds to this one."
  (interactive)
  (setq CorrespondingFileName nil)
  (setq BaseFileName (file-name-sans-extension buffer-file-name))
  (if (string-match "\\.c" buffer-file-name)
      (setq CorrespondingFileName (concat BaseFileName "\\.h")))
  (if (string-match "\\.h" buffer-file-name)
  (if (file-exists-p (concat BaseFileName ".c")) (setq CorrespondingFileName (concat BaseFileName ".c"))
      (setq CorrespondingFileName (concat BaseFileName ".cpp"))))
  (if (string-match "\\.hin" buffer-file-name)
      (setq CorrespondingFileName (concat BaseFileName ".cin")))
  (if (string-match "\\.cin" buffer-file-name)
       (setq CorrespondingFileName (concat BaseFileName ".hin")))
  (if (string-match "\\.cpp" buffer-file-name)
       (setq CorrespondingFileName (concat BaseFileName ".h")))
  (if CorrespondingFileName (find-file CorrespondingFileName)
       (error "Unable to find a corresponding file")))

(defun solis-find-corresponding-file-other-window ()
  "Find the file that corresponds to this one."
  (interactive)
  (find-file-other-window buffer-file-name)
  (solis-find-corresponding-file)
  (other-window -1))
  (define-key c++-mode-map [f12] 'solis-find-corresponding-file)
  (define-key c++-mode-map [M-f12] 'solis-find-corresponding-file-other-window)

(setq cc-other-file-alist
      '(("\\.c"   (".h"))
       ("\\.cpp"   (".h"))
       ("\\.h"   (".c"".cpp"))))

(setq ff-search-directories
      '("../"))

;;; Bind the toggle function to a global key
(global-set-key "\M-p" 'ff-find-other-file)

  ; devenv.com error parsing
  (add-to-list 'compilation-error-regexp-alist 'solis-devenv)
  (add-to-list 'compilation-error-regexp-alist-alist '(solis-devenv
   "*\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) : \\(?:see declaration\\|\\(?:warnin\\(g\\)\\|[a-z ]+\\) C[0-9]+:\\)"
    2 3 nil (4)))
)

; Compilation
(require 'compile)

; Setup my compilation mode
(defun solis-compilation-hook ()
  (make-local-variable 'truncate-lines)
  (setq truncate-lines nil)
)
(add-hook 'compilation-mode-hook 'solis-compilation-hook)

(setq compilation-context-lines 0)                                                          
(setq compilation-error-regexp-alist
    (cons '("^\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) : \\(?:fatal error\\|warnin\\(g\\)\\) C[0-9]+:" 2 3 nil (4))
     compilation-error-regexp-alist))

(defun find-project-directory-recursive ()
  "Recursively search for a makefile."
  (interactive)
  (if (file-exists-p solis-makescript) t
      (cd "../"); added /build_scripts
      (find-project-directory-recursive)))

(defun lock-compilation-directory ()
  "The compilation process should NOT hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked t)
  (message "Compilation directory is locked."))

(defun unlock-compilation-directory ()
  "The compilation process SHOULD hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked nil)
  (message "Compilation directory is roaming."))

(defun find-project-directory ()
  "Find the project directory."
  (interactive)
  (setq find-project-from-directory default-directory)
  (switch-to-buffer-other-window "*compilation*")
  (if compilation-directory-locked (cd last-compilation-directory)
  (cd find-project-from-directory)
  (find-project-directory-recursive)
  (setq last-compilation-directory default-directory)))

(defun make-without-asking ()
  "Make the current build."
  (interactive)
  (if (find-project-directory) (compile solis-makescript))
  )
(define-key global-map "\em" 'make-without-asking)

; showing and hiding blocks of code
(add-hook 'c-mode-common-hook
  (lambda()
    (local-set-key (kbd "C-c <right>") 'hs-show-block)
    (local-set-key (kbd "C-c <left>")  'hs-hide-block)
    (local-set-key (kbd "C-c <up>")    'hs-hide-all)
    (local-set-key (kbd "C-c <down>")  'hs-show-all)
    (hs-minor-mode t)))

(defun bury-compile-buffer-if-successful (buffer string)
  "Bury a compilation buffer if succeeded without warnings "
  (if (and
       (string-match "compilation" (buffer-name buffer))
       (string-match "finished" string)
       (not
        (with-current-buffer buffer
          (search-forward "warning" nil t))))
      (run-with-timer 1 nil
                      (lambda (buf)
                        (bury-buffer buf)
                        (switch-to-prev-buffer (get-buffer-window buf) 'kill))
                      buffer)))
(add-hook 'compilation-finish-functions 'bury-compile-buffer-if-successful)

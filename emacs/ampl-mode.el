;;===============================================;;
;;===============================================;;
;;                                               ;;
;;        Ampl mode for the Emacs editor.        ;;
;;                                               ;;
;;   Dominique Orban.     Chicago,  March 2003.  ;;
;;                        Montreal, March 2008.  ;;
;;                                               ;;
;;   dominique.orban@gmail.com                   ;;
;;                                               ;;
;;===============================================;;
;;===============================================;;

;; Author: Dominique Orban <dominique.orban@gmail.com>
;; Keywords: Ampl
;; Version: 0.1
;; Time stamp: "Wed 25 Sep 2013 10:55:10 EDT"

;; Purpose: Provides syntax highlighting and basic indentation for
;;  models written in Ampl. Ampl is a modeling language for
;;  optimization programs.  See www.ampl.com for more information.
;;  This file is still under development, features will be added as
;;  time allows. One of these, which I hope to provide in the
;;  not-too-distant future is the ability to run an Ampl process in an
;;  Emacs window to facilitate model debugging and running.

;; If you find this mode useful, please let me know <dominique.orban@gmail.com>

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This file is NOT part of GNU Emacs.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with the Emacs program; see the file COPYING.  If not, write
;; to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;; ======================  C O D E  ================================

;; Version number and author
(defconst ampl-mode-version-number "0.1"
  "Version of ampl-mode.el")

(defconst ampl-mode-author "Dominique Orban <dominique.orban@polymtl.ca>"
  "Author of ampl-mode.el")

;; ====================== S E T U P =================================

;; Ampl major mode setup
(defvar ampl-mode-hook nil
  "*List of functions to call when entering Ampl mode.")

;; Default keymap is nil
(defvar ampl-mode-map nil "Keymap for Ampl major mode.")

;; Load Ampl keymap if nil
;; The Ampl keymap auto-closes parentheses, brackets and quotes
(if ampl-mode-map
    nil        ; Do nothing if keymap was already loaded
  (setq ampl-mode-map (make-sparse-keymap))
  (define-key ampl-mode-map "("     'ampl-insert-parens)
  (define-key ampl-mode-map "["     'ampl-insert-sqbrackets)
  (define-key ampl-mode-map "{"     'ampl-insert-curlies)
  (define-key ampl-mode-map "\""    'ampl-insert-double-quotes)
  (define-key ampl-mode-map "'"     'ampl-insert-single-quotes)
  (define-key ampl-mode-map "\C-co" 'ampl-insert-comment))

;; Files whose extension is .mod, .dat or .ampl will be edited in Ampl mode
(setq auto-mode-alist
      (append
       '(("\\(.mod\\|.dat\\|.ampl\\)\\'" . ampl-mode))
       auto-mode-alist))

(autoload 'ampl-mode "Ampl" "Entering Ampl mode..." t)

;; ============= K E Y W O R D   H I G H L I G H T I N G ============

;; Keyword highlighting: model and data statements
;; may be followed by a name, must be followed by a semicolon.
(defconst ampl-font-lock-model-data
  (list '( "\\(data\\|model\\)\\(.*;\\)" . (1 font-lock-builtin-face keep t)))
  "Reserved keywords highlighting")

(defconst ampl-font-lock-model-data-names
  (append ampl-font-lock-model-data
          (list '( "\\(data\\|model\\)\\(.*\\)\\(;\\)" . (2 font-lock-constant-face keep t))))
  "Model and data filenames highlighting")

;; Other reserved keywords
(defconst ampl-font-lock-keywords-reserved
  (append ampl-font-lock-model-data-names
	  (list '("\\(^\\|[ \t]+\\|[({\[][ \t]*\\)\\(I\\(?:N\\(?:OUT\\)?\\|nfinity\\)\\|LOCAL\\|OUT\\|a\\(?:nd\\|r\\(?:c\\|ity\\)\\)\\|b\\(?:\\(?:inar\\)?y\\)\\|c\\(?:ard\\|heck\\|ircular\\|o\\(?:eff\\|mplements\\|ver\\)\\)\\|d\\(?:ata\\|efault\\|i\\(?:ff\\|men\\|splay\\)\\)\\|e\\(?:lse\\|xists\\)\\|f\\(?:irst\\|orall\\|rom\\)\\|i\\(?:n\\(?:clude\\|dexarity\\|te\\(?:ger\\|r\\(?:val\\)?\\)\\)\\|n\\)\\|l\\(?:ast\\|e\\(?:ss\\|t\\)\\)\\|m\\(?:aximize\\|ember\\|inimize\\)\\|n\\(?:extw?\\|o\\(?:de\\|t\\)\\)\\|o\\(?:bj\\|ption\\|r\\(?:d\\(?:0\\|ered\\)?\\)?\\)\\|p\\(?:aram\\|r\\(?:evw?\\|intf\\)\\)\\|re\\(?:peat\\|versed\\)\\|s\\(?:\\.t\\.\\|et\\(?:of\\)?\\|olve\\|u\\(?:bject to\\|ffix\\)\\|ymbolic\\)\\|t\\(?:able\\|hen\\|o\\)\\|un\\(?:ion\\|til\\)\\|var\\|w\\(?:hile\\|ithin\\)\\)\\({\\|[ \t]+\\|[:;]\\)" . (2 font-lock-builtin-face keep t))))
  "Reserved keywords highlighting-1")

;; 'if' is a special case as it may take the forms
;; if(i=1), if( i=1 ), if ( i=1 ), if i==1, etc.
(defconst ampl-font-lock-keywords-reserved2
  (append ampl-font-lock-keywords-reserved
	  (list '("\\(^\\|[ \t]+\\|[({\[][ \t]*\\)\\(if\\)\\([ \t]*(\\|[ \t]+\\)" . (2 font-lock-builtin-face keep t))))
  "Reserved keywords highlighting-2")

;; 'Infinity' is another special case as it may
;; appear as -Infinity...
(defconst ampl-font-lock-keywords-reserved3
  (append ampl-font-lock-keywords-reserved2
	  (list '("\\(^\\|[ \t]+\\|[({\[][ \t]*\\)\\(-[ \t]*\\)\\(Infinity\\)\\([ \t]*(\\|[ \t]+\\)" . (3 font-lock-builtin-face keep t))))
  "Reserved keywords highlighting-3")

;; Built-in operators highlighting
;; must be followed by an opening parenthesis
(defconst ampl-font-lock-keywords-ops
  (append ampl-font-lock-keywords-reserved3
	  (list '("\\(a\\(?:bs\\|cosh?\\|lias\\|sinh?\\|tan[2h]?\\)\\|c\\(?:eil\\|os\\|time\\)\\|exp\\|floor\\|log\\(?:10\\)?\\|m\\(?:ax\\|in\\)\\|precision\\|round\\|s\\(?:inh?\\|qrt\\)\\|t\\(?:anh?\\|ime\\|runc\\)\\)\\([ \t]*(\\)" . (1 font-lock-function-name-face t t))))
  "Built-in operators highlighting")

;; Random number generation functions
;; must be followed by an opening parenthesis
(defconst ampl-font-lock-keywords-rand
  (append ampl-font-lock-keywords-ops
	  (list '("\\(Beta\\|Cauchy\\|Exponential\\|Gamma\\|Irand224\\|Normal\\(?:01\\)?\\|Poisson\\|Uniform\\(?:01\\)?\\)\\([ \t]*(\\)" . (1 font-lock-function-name-face t t))))
  "Random number generation functions")

;; Built-in operators with iterators
;; must be followed by an opening curly brace
(defconst ampl-font-lock-keywords-iterate
  (append ampl-font-lock-keywords-rand
	  (list '("\\(prod\\|sum\\)\\([ \t]*{\\)" . (1 font-lock-function-name-face t t))))
  "Built-in operators with iterators")

;; Constants, parameters and names
;; follow the keywords param, let, set, var, minimize, maximize, option or 'subject to'
(defconst ampl-font-lock-constants1
  (append ampl-font-lock-keywords-iterate
	  (list '("\\(^[ \t]*\\)\\(display\\|let\\|m\\(?:\\(?:ax\\|in\\)imize\\)\\|option\\|param\\|s\\(?:\\.t\\.\\|et\\|ubject to\\)\\|var\\)\\([ \t]*\\)\\([a-zA-Z0-9\-_]+\\)\\([ \t]*.*[;:]\\)" . (4 font-lock-constant-face t t))))
  "Constants, parameters and names")

;; Constants may also be defined after a set specification
;; This does not involve 'option'
;; e.g. let {i in 1..5} x[i] := 0;
(defconst ampl-font-lock-constants2
  (append ampl-font-lock-constants1
	  (list '("\\(^[ \t]*\\)\\(display\\|let\\|m\\(?:\\(?:ax\\|in\\)imize\\)\\|param\\|s\\(?:\\.t\\.\\|et\\|ubject to\\)\\|var\\)\\([ \t]+\\)\\({.*}\\)\\([ \t]*\\)\\([a-zA-Z0-9\-_]+\\)\\([ \t]*.*[;:]\\)" . (6 font-lock-constant-face t t))))
  "Constants, parameters and names")

;; Comments
;; start with a hash, end with a newline
(setq comment-start "#")
(defconst ampl-font-lock-comments
  (append ampl-font-lock-constants2
	  (list '( "\\(#\\).*$" . (0 font-lock-comment-face t t))))
  "Comments")

;; Define default highlighting level
(defvar ampl-font-lock-keywords ampl-font-lock-comments
  "Default syntax highlighting level in Ampl mode")

;; ==================== I N D E N T A T I O N ====================

;; Indentation --- Fairly simple for now
;;  1) If a line ends with a semicolon, the next line is flush left
;;  2) If a line ends with a colon or an equal sign, the next line is indented.
(defun ampl-indent-line ()
  "Indent current line of Ampl code"
  (interactive)
  (let ((position 0)
        (reason nil))

    (save-excursion
      (beginning-of-line)   ; Set point to beginning of line

      ;; Flush left at beginning of buffer
      (if (bobp)
          (prog1
              (setq position 0)
            (setq reason "top of buffer"))

        (progn
          (forward-line -1) ; move point to beginning of previous line, if any
          (if (looking-at ".*[:=][ \t]*$") ; if previous line ends with : or =
              (prog1
                  (setq position tab-width) ; indent
                (setq reason "previous line ends in : or ="))
            (prog1
                (setq position 0)  ; otherwise, do not indent
              (setq reason "nothing special"))
            )
          )
        )
      )
    (message "Indentation column will be %d (%s)" position reason)
    (indent-line-to position))
  )

;; ================= U S E R   C O M M A N D S ======================

(defvar ampl-auto-close-parenthesis t
  "# Automatically insert closing parenthesis if non-nil")

(defvar ampl-auto-close-brackets t
  "# Automatically insert closing square bracket if non-nil")

(defvar ampl-auto-close-curlies t
  "# Automatically insert closing curly brace if non-nil")

(defvar ampl-auto-close-double-quote t
  "# Automatically insert closing double quote if non-nil")

(defvar ampl-auto-close-single-quote t
  "# Automatically insert closing single quote if non-nil")

(defvar ampl-user-comment
  "#####
##  %
#####
"
  "# User-defined comment template." )

;; ====================== S Y N T A X   T A B L E ==================

;; Syntax table for Ampl major mode
(defvar ampl-mode-syntax-table nil
  "Syntax table for Ampl mode.")

;; Load Ampl syntax table if not already loaded
(defun ampl-create-syntax-table ()
  (if ampl-mode-syntax-table
      nil   ; Do nothing
    (setq ampl-mode-syntax-table (make-syntax-table))
    (set-syntax-table ampl-mode-syntax-table)

    ;; Indicate that underscore may be part of a word
    (modify-syntax-entry ?_ "w" ampl-mode-syntax-table)

    ;; Comments start with a hash and end with a newline
    (modify-syntax-entry ?# "<" ampl-mode-syntax-table)
    (modify-syntax-entry ?\n ">" ampl-mode-syntax-table)
    ))

;; ================= A M P L   M A J O R   M O D E ===============

;; Definition of Ampl major mode
(defun ampl-mode ()
  "Major mode for editing Ampl models.\nSpecial commands:\n\\{ampl-mode-map}"
  (interactive)
  (kill-all-local-variables)

  ;; Load syntax table
  (ampl-create-syntax-table)

  ;; Highlight Ampl keywords
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(ampl-font-lock-keywords))

  ;; Indent Ampl commands
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'ampl-indent-line)

  ;; Application of user commands

  (defun ampl-insert-comment ()
    "Insert a comment template defined by `ampl-user-comment'."
    (interactive)
    (let ((point-a (point))
	  (use-comment ampl-user-comment)
	  point-b point-c)
      (insert ampl-user-comment)
      (setq point-b (point))

      (goto-char point-a)
      (if (re-search-forward "%" point-b t)
	  (progn
	    (setq point-c (match-beginning 0))
	    (replace-match ""))
	(goto-char point-b))
      ))

  (defun ampl-insert-parens (arg)
    "Insert parenthesis pair. See ampl-auto-close-parenthesis."
    (interactive "p")
    (if ampl-auto-close-parenthesis
	(progn
	  (insert "()")
	  (backward-char 1))
      (insert "(")))

  (defun ampl-insert-sqbrackets (arg)
    "Insert square brackets pair. See ampl-auto-close-brackets."
    (interactive "p")
    (if ampl-auto-close-brackets
	(progn
	  (insert "[]")
	  (backward-char 1))
      (insert "[")))

  (defun ampl-insert-curlies (arg)
    "Insert curly braces pair. See ampl-auto-close-curlies."
    (interactive "p")
    (if ampl-auto-close-curlies
	(progn
	  (insert "{}")
	  (backward-char 1))
      (insert "{")))

  (defun ampl-insert-double-quotes (arg)
    "Insert double quotes pair. See ampl-auto-close-double-quotes."
    (interactive "p")
    (if ampl-auto-close-double-quote
	(progn
	  (insert "\"\"")
	  (backward-char 1))
      (insert "\"")))

  (defun ampl-insert-single-quotes (arg)
    "Insert single quotes pair. See ampl-auto-close-single-quotes."
    (interactive "p")
    (if ampl-auto-close-single-quote
	(progn
	  (insert "''")
	  (backward-char 1))
      (insert "'")))

  ;; End of user commands

  (setq major-mode 'ampl-mode)
  (setq mode-name "Ampl")
  (use-local-map ampl-mode-map)   ; Load Ampl keymap
  (run-mode-hooks 'ampl-mode-hook)
)

(provide 'ampl-mode)  ; So others can (require 'ampl-mode)

;; ======================  E N D   O F   A M P L . E L  ========================

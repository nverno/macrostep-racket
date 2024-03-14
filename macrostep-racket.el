;;; macrostep-racket.el --- Interactive macro expander for racket -*- lexical-binding: t; -*-

;; Author: Noah Peart <noah.v.peart@gmail.com>
;; URL: https://github.com/nverno/macrostep-racket
;; Version: 0.0.1
;; Package-Requires: ((emacs "27") (racket-mode "1"))
;; Keywords: racket, languages, macro, debugging
;; Created: 14 March 2024

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;;  Expand racket macros interactively using the macrostep interface.
;;
;; - macrostep interface:
;; 	+ macrostep-sexp-bounds-function
;;	+ macrostep-sexp-at-point-function
;;	+ macrostep-environment-at-point-function
;;	+ macrostep-expand-1-function
;;	+ macrostep-print-function
;;
;;; Code:

(require 'macrostep)
(require 'racket-stepper)


(put 'macrostep-racket-non-macro 'error-conditions
     '(macrostep-racket-non-macro error))
(put 'macrostep-racket-non-macro 'error-message
     "Text around point is not a macro call.")

(put 'macrostep-racket-not-found 'error-conditions
     '(macrostep-racket-not-found error))
(put 'macrostep-racket-not-found 'error-message
     "Macro value not found for: ")

;; Return the bounds of the macro at point
(defun macrostep-racket-sexp-bounds ()
  ;; TODO: find better bounds
  (or (bounds-of-thing-at-point 'list)
      (signal 'macrostep-racket-non-macro nil)))

;; Return => `macrostep-expand-1-function'
(defun macrostep-racket-sexp-at-point (start end)
  (cons start end))

;; Expand macro `macrostep-expand-1-function'
(defun macrostep-racket-expand-1 (region _ignore)
  ;; TODO: get macroexpansion for REGION
  (buffer-substring-no-properties (car region) (cdr region)))

;; Insert expansion and propertize any nested macros
(defun macrostep-racket-print (sexp _env)
  (let* ((beg (point))
         (end (progn (insert sexp)
                     (point))))
    (goto-char beg)
    ;; TODO: find nested macros and propertize
    ;; (put-text-property (match-beginning 1) (1+ (match-beginning 1))
    ;;                    'macrostep-macro-start t)
    (goto-char end)))

;;;###autoload
(defun macrostep-racket-hook ()
  "Main hook to set variables for `macrostep' to function."
  (setq macrostep-sexp-bounds-function          #'macrostep-racket-sexp-bounds)
  (setq macrostep-sexp-at-point-function        #'macrostep-racket-sexp-at-point)
  (setq macrostep-environment-at-point-function #'ignore)
  (setq macrostep-expand-1-function             #'macrostep-racket-expand-1)
  (setq macrostep-print-function                #'macrostep-racket-print))

;;;###autoload
(add-hook 'racket-mode-hook #'macrostep-racket-hook)

(provide 'macrostep-racket)
;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:
;;; macrostep-racket.el ends here

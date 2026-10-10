#!/bin/sh
# KH Coder は Perl/Tk 804.034 以下のときだけ、日本語ファイル名に対応した
# FBox_kh2 を読み込む。本環境は IME の確定入力のため 804.036 を使うので、事前に読み込む。
cd /KHCoder/khcoder || exit 1
exec perl -I./kh_lib -MTk::FBox -MTk::FBox_kh2 kh_coder.pl "$@"

#!/bin/bash

function push {
 
 
  git config --global user.email "anmol@clouddrove.com"
  git config --global user.name "Anmol Nagpal"
  git add . && git commit -m "upload"
  git push origin master
}
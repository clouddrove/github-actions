#!/bin/bash

function push {
 
 
  git config --global user.email "ajay@clouddrove.com"
  git config --global user.name "Ajay dhyani"
  git add . && git commit -m "upload"
  git push origin master
}
---
title: "Intro to Health Informatics (CS 6440)"
date: 2016-05-14
tags: ["georgia tech"]
draft: false
---

# Introduction

This course and health informatics could be summarized as:

*The study and transformation of a fragmented and poorly coordinated health care system into utilizing digital information for patient's health.*

The course served as a survey of the US health care system and various technologies and standards that are attempting to transform the industry.

# Project Gamification

For the course project myself and my teammates developed a web-based patient survey application that incorporated elements of gamification and interfaced with a HL7 FHIR health data server.

## Patient Surveys

Anyone who has been to any doctor or health system knows how the first thing you must do before doing anything else is complete a survey. Generally it contains basic personal information, health history, and then any symptoms or current conditions. While there are many locations that are not placing these same surveys online they are lack the clean, elegant interfaces that many have come to expect.

## Gamification

In terms of gamification we wanted to add an element above and beyond making a survey look pretty. Gamification is applying game-design elements and principles in non-game situations. As the latest generations have been brought up on video games, adding a form of fun or goal achievements to doing other tasks has grown in popularity.

## HL7 FHIR

The final component was the interaction with the HL7 FHIR server. FHIR stands for Fast Healthcare Interoperability Resources and is a specification for exchanging health care information electronically. It has grown in use over the past few years due to various health care laws that have been put in place.

Our gamification project would take our questionnaires and the responses and upload them directly to the server we were utilizing.

# References

* [FHIR Website](http://hl7.org/fhir/)
* [SMART on FHIR Spec](http://docs.smarthealthit.org/)
* [HAPI FHIR Java API](http://jamesagnew.github.io/hapi-fhir/)
* [FHIR Server - Michigan Health](http://52.72.172.54:8080/fhir/home?encoding=null&pretty=null)
* [FHIR Server - Georgia Tech](http://polaris.i3l.gatech.edu:8080/gt-fhir-webapp/home?encoding=null&pretty=null)

# Summary

This was the final course required to complete my specializing in [Interactive Intelligence](http://www.omscs.gatech.edu/specialization-interactive-intelligence/).

The [course website](http://www.omscs.gatech.edu/cs-6440-intro-health-informatics/) provides a good overview of what to expect.

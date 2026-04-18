# Satellite Link Budget Simulator & Mission Monitor

A real-time MATLAB-based simulation tool designed to analyze and visualize the communication link budget for Low Earth Orbit (LEO) satellites. This project demonstrates the relationship between orbital geometry and signal degradation using dynamic visualization.

## Overview
In satellite communications, the **Link Budget** is a critical calculation that accounts for all gains and losses from the transmitter to the receiver. This simulator models a satellite overpass, calculating real-time **Free Space Path Loss (FSPL)** and comparing the received signal strength ($P_{rx}$) against hardware sensitivity limits.

### Key Features
* **Live Animation:** Two-panel dashboard showing physical satellite movement vs. real-time data tracking.
* **Seamless Loop:** Implements a "Ping-Pong" path algorithm for continuous tracking visualization.
* **Status Logic:** Real-time state handling that identifies "Good," "Weak," and "Loss of Signal" (LOS) conditions.
* **Visual Dashboards:** Color-coded signal zones for intuitive engineering analysis.

## Technical Details

### 1. Geometry: Slant Range
The simulator calculates the direct distance ($d$) between the Ground Station and the Satellite using the Pythagorean theorem for each time step:
$$d = \sqrt{x^2 + h^2}$$
*where x is ground distance and h is altitude.*

### 2. Physics: Free Space Path Loss (FSPL)
The core signal degradation is modeled using the FSPL equation:
$$FSPL (dB) = 20 \log_{10}(d) + 20 \log_{10}(f) + 20 \log_{10}\left(\frac{4\pi}{c}\right)$$
*where f is frequency (437 MHz) and c is the speed of light.*

### 3. Link Budget Logic
The received power is determined by:
$$P_{rx} = P_{tx} + G_{total} - FSPL$$

## Dashboard Preview


https://github.com/user-attachments/assets/6af62c80-b90a-4bb2-9730-0b89c823dfc8


* **Left Panel:** Visual representation of the satellite's trajectory across the ground station's horizon.
* **Right Panel:** Dynamic graph of signal strength ($dBm$) vs. Slant Range ($km$).

> **Note:** Red regions indicate signal levels below the hardware sensitivity threshold (-120 dBm).

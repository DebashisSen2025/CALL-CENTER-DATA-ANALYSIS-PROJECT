# 📞 Call Center Data Analysis | SQL Project

> SQL-based analysis of call center operations data to uncover
> customer sentiment patterns, CSAT score drivers, response time
> efficiency, and channel performance — enabling data-driven
> decisions to improve customer support.

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![CSV](https://img.shields.io/badge/Dataset-CSV-green?style=for-the-badge&logo=files&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)

---

## 📌 Project Overview

| Detail      | Info                                          |
|-------------|-----------------------------------------------|
| Tool        | MySQL Workbench                               |
| Dataset     | Call Center.csv                               |
| Techniques  | Data Cleaning, Aggregation, Window Functions  |
| Domain      | Customer Service / Operations Analytics       |
| Status      | ✅ Completed                                  |

---

## 🎯 Business Questions Answered

- ✅ What is the total call volume by city and state?
- ✅ Which call center has the best response time performance?
- ✅ What is the sentiment distribution across all calls?
- ✅ How does CSAT score vary by channel and call reason?
- ✅ What are the peak call days and average call durations?
- ✅ Which reasons drive the most negative customer sentiment?

---

## 🔍 Key Analysis Performed

### 📊 Call Volume Analysis
- Total calls distribution by city and state
- Peak call days and time-of-day patterns
- Channel-wise call breakdown (call centre, chatbot, email, web)

### 😊 Sentiment & CSAT Analysis
- Customer sentiment classification — Positive, Neutral, Negative
- CSAT score distribution and average by call center
- Correlation between response time and customer satisfaction

### ⏱️ Response Time Performance
- Average call duration by call center and reason
- Response time benchmarking — Within SLA vs Below SLA
- Agent performance comparison across locations

### 📋 Data Cleaning Applied
- Handled missing CSAT scores (NULL treatment)
- Standardized sentiment labels
- Removed duplicate call records
- Converted date/time columns to proper format

---

## 🧮 Sample SQL Queries
```sql

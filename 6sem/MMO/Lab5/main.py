import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import pydotplus
import seaborn as sns
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score
from sklearn.impute import SimpleImputer
import warnings
warnings.filterwarnings("ignore")  # чтобы убрать предупреждения

print("=============================== Задание 1 ===============================")
table = pd.read_csv("1.04. Real-life example.csv")
print(table.head())

print("=============================== Задание 2 ===============================")
numeric_cols = table.select_dtypes(include=['float64', 'int64']).columns

corr_matrix = table[numeric_cols].corr()

plt.figure(figsize=(12, 8))
sns.heatmap(corr_matrix, annot=True, cmap='coolwarm', fmt=".2f")
plt.title('Матрица корреляций')
plt.show()

# Тепловая карта состоит из квадратов, цвет которых показывает значение корреляции между двумя переменными:
# Чем ближе значение корреляции к 1 или -1, тем сильнее линейная зависимость между переменными.
# Значения, близкие к 0, указывают на отсутствие линейной зависимости.
# Также, если значение корреляции положительное, это означает прямую линейную зависимость
# (одна переменная растет, другая также растет), а если отрицательное — обратную (одна переменная растет, другая уменьшается).

print("=============================== Задание 3 ===============================")
sns.pairplot(table[numeric_cols])
plt.suptitle('Матрица диаграмм рассеяния', y=1.02)
plt.show()

# Матрица диаграмм рассеяния показывает отношения между парами переменных в датасете.
# Каждая ячейка на диаграмме рассеяния показывает отношение между двумя переменными: по оси X одна переменная,
# по оси Y — другая переменная. На диаграммах рассеяния также изображена линия регрессии, которая помогает
# визуально оценить направление и силу линейной зависимости между переменными.

print("=============================== Задание 4 ===============================")
print("Коэффициенты корреляции:")
print(corr_matrix)

# Диаграмма рассеяния для зависимости Price от Year
plt.figure(figsize=(10, 6))
sns.scatterplot(x='Year', y='Price', data=table)
plt.title('Зависимость Price от Year')
plt.show()

print("=============================== Задание 5 ===============================")
table = table.dropna(subset=['Price'])

X = table[['Year']]
y = table['Price']

model = LinearRegression().fit(X, y)
y_pred = model.predict(X)

# Получение коэффициентов уравнения линейной регрессии
beta_0 = model.intercept_
beta_1 = model.coef_[0]

print(f"Уравнение линейной регрессии: y = {beta_0:.2f} + {beta_1:.2f} * X")

plt.figure(figsize=(10, 6))
sns.scatterplot(x='Year', y='Price', data=table)
plt.title('Зависимость Price от Year')
plt.plot(X, y_pred, color='red')  # линия регрессии
plt.show()


print("=============================== Задание 6 ===============================")
print(f"Коэффициент детерминации (R^2): {r2_score(y, y_pred):.2f}")

print("=============================== Задание 7 ===============================")
# Предварительная обработка данных
imputer = SimpleImputer(strategy='mean')
X_multi = imputer.fit_transform(table[['Year', 'Mileage', 'EngineV']])
model_multi = LinearRegression().fit(X_multi, y)
y_pred_multi = model_multi.predict(X_multi)

print("=============================== Задание 8 ===============================")
# Оценка качества модели с несколькими параметрами
print(f"Коэффициент детерминации для модели с несколькими параметрами (R^2): {r2_score(y, y_pred_multi):.2f}")
import pandas as pd
import numpy as np
from sklearn.model_selection import cross_val_score, train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
from sklearn.feature_selection import VarianceThreshold
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
import time
import warnings
warnings.filterwarnings("ignore")

print("=============================== Задание 1 ===============================")
data = pd.read_csv('breast-cancer.csv')
data.head()
data["diagnosis"] = data["diagnosis"].map({"B": 1, "M": 2})

print("=============================== Задание 2 ===============================")
# Признаки для дальнейшего анализа
features = data.drop(columns=['id', 'diagnosis'])
target = data['diagnosis']

X_train, X_test, y_train, y_test = train_test_split(features, target, test_size=0.2, random_state=42)

# Модель случайного леса

"""
Модель случайного леса (Random Forest) является ансамблевой моделью машинного обучения, 
которая комбинирует несколько деревьев принятия решений (Decision Tree). 
Каждое дерево обучается на случайной подвыборке данных, а затем их прогнозы объединяются 
для получения окончательного прогноза модели. 
"""

rf_model = RandomForestClassifier(random_state=42)

rf_model.fit(X_train, y_train)

y_pred = rf_model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)

print(f'Точность модели случайного леса: {accuracy:.4f}')

print("=============================== Задание 3-4 ===============================")
threshold = 0.02  # Порог дисперсии
selector = VarianceThreshold(threshold=threshold)
features_reduced = selector.fit_transform(features)

X_train, X_test, y_train, y_test = train_test_split(features_reduced, target, test_size=0.2, random_state=42)
rf_model = RandomForestClassifier(random_state=42)

rf_model.fit(X_train, y_train)

y_pred = rf_model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)

print(f'Точность модели случайного леса после отбора признаков с низкой дисперсией: {accuracy:.4f}')

print("=============================== Задание 5-6 ===============================")
# # Метод PCA с 3 главными компонентами
# pca = PCA(n_components=3)
# features_pca = pca.fit_transform(features)
#
# fig = plt.figure(figsize=(10, 8))
# ax = fig.add_subplot(111, projection='3d')
#
# # Визуализация данных по целевому признаку для разных цветов точек
# for target_value in data['diagnosis'].unique():
#     mask = (target == target_value)
#     ax.scatter(features_pca[mask, 0], features_pca[mask, 1], features_pca[mask, 2], label=target_value)
#
# ax.set_xlabel('Первая главная компонента')
# ax.set_ylabel('Вторая главная компонента')
# ax.set_zlabel('Третья главная компонента')
#
# ax.set_title('Трехмерная визуализация PCA')
# ax.legend()
# plt.show()


# Метод PCA с 2 главными компонентами

"""
PCA (Principal Component Analysis) - это метод анализа данных, используемый для 
снижения размерности данных и выделения наиболее информативных признаков. 
Он проецирует исходные признаки на новое пространство, образованное главными компонентами, 
которые являются линейными комбинациями исходных признаков. Главные компоненты упорядочены 
по убыванию доли объясненной дисперсии и позволяют оставить наибольшую изменчивость в данных 
при снижении размерности. Визуализация данных в пространстве главных компонент помогает 
исследовать структуру данных и выявлять закономерности.
"""

pca = PCA(n_components=2)
features_pca = pca.fit_transform(features)

plt.figure(figsize=(8, 6))
# Визуализация данных по целевому признаку для разных цветов точек
for target_value in data['diagnosis'].unique():
    mask = (target == target_value)
    plt.scatter(features_pca[mask, 0], features_pca[mask, 1], label=target_value)

plt.xlabel('Первая главная компонента')
plt.ylabel('Вторая главная компонента')
plt.title('Двухмерная визуализация PCA')
plt.legend()
plt.show()

print("=============================== Задание 7 ===============================")
X_train, X_test, y_train, y_test = train_test_split(features_pca, target, test_size=0.2, random_state=42)
rf_model = RandomForestClassifier(random_state=42)
start_time = time.time()
rf_model.fit(X_train, y_train)
y_pred = rf_model.predict(X_test)
end_time = time.time()
accuracy = accuracy_score(y_test, y_pred)
elapsed_time = end_time - start_time

print(f'Точность модели случайного леса на PCA с двумя компонентами: {accuracy:.4f}')
print(f'Время обучения и предсказаний: {elapsed_time:.4f} секунд')

print("=============================== Задание 8 ===============================")
data["diagnosis"]=data["diagnosis"].map({"B": 1, "M": 2})
data.head()

features = data.drop(columns=['id', 'diagnosis'])

pca = PCA()
pca.fit(features)

# Накопленное объясненное отклонение
cumulative_explained_variance = pca.explained_variance_ratio_.cumsum()

# Кол-во главных компонент, чтобы сохранить 90% дисперсии
num_components = next(i for i, v in enumerate(cumulative_explained_variance) if v >= 0.9) + 1

print(f'Количество главных компонент, необходимых для сохранения 90% дисперсии: {num_components}')

plt.figure(figsize=(8, 6))
plt.plot(range(1, len(cumulative_explained_variance) + 1), cumulative_explained_variance)
plt.xlabel('Количество главных компонент')
plt.ylabel('Накопленное объясненное отклонение')
plt.title('График зависимости накопленного объясненного отклонения от количества главных компонент')
plt.axhline(y=0.9, color='r', linestyle='--')
plt.show()

print("=============================== Задание 9 ===============================")
pca_variance = np.cumsum(pca.explained_variance_ratio_)
plt.plot(pca_variance)
plt.xlabel('Количество главных компонент')
plt.ylabel('Общая объясненная дисперсия')
plt.title('График зависимости объясненной дисперсии от количества главных компонент')
plt.grid(True)
plt.show()
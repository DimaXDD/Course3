import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
from sklearn.feature_selection import VarianceThreshold
from sklearn.decomposition import PCA
import time
import warnings
warnings.filterwarnings("ignore")

print("=============================== Задание 1 ===============================")
data = pd.read_csv('data.csv')
print(data.head())

print("=============================== Задание 2 ===============================")
"""
Модель случайного леса - это тип ансамблевой модели машинного обучения, которая состоит из 
множества деревьев решений. Каждое дерево в случайном лесу строится независимо друг от друга, 
на основе подвыборок обучающего набора данных (bootstrap samples), а также случайного подмножества 
признаков для каждого разделения в узлах деревьев.
"""

X = data.drop(columns=['Class'])
y = data['Class']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

rf_classifier = RandomForestClassifier()
rf_classifier.fit(X_train, y_train)

y_pred = rf_classifier.predict(X_test)

accuracy = accuracy_score(y_test, y_pred)
print("Точность модели случайного леса:", accuracy)

print("=============================== Задание 3 ===============================")
print("Количество параметров до сокращения:", X.shape[1])

selector = VarianceThreshold(threshold=80000)
X_reduced = selector.fit_transform(X)

print("Количество параметров после сокращения:", X_reduced.shape[1])

print("=============================== Задание 4 ===============================")
X_train_reduced, X_test_reduced, y_train, y_test = train_test_split(X_reduced, y, test_size=0.2, random_state=42)

rf_classifier_reduced = RandomForestClassifier()
rf_classifier_reduced.fit(X_train_reduced, y_train)

y_pred_reduced = rf_classifier_reduced.predict(X_test_reduced)

accuracy_reduced = accuracy_score(y_test, y_pred_reduced)
print("Точность модели случайного леса на сокращенном датасете:", accuracy_reduced)

print("=============================== Задание 5 ===============================")
"""
Метод главных компонент (PCA, Principal Component Analysis) - это метод многомерного 
статистического анализа, который используется для уменьшения размерности данных, 
сохраняя при этом максимальное количество информации
"""

"""
"Объясненная дисперсия двух главных компонент" представляет собой долю общей дисперсии, 
которая объясняется этими двумя главными компонентами. В вашем случае, сумма объясненной 
дисперсии двух главных компонент составляет примерно 0.999973, что означает, что эти две 
главные компоненты объясняют около 99.9973% дисперсии исходных данных.
Это показывает, что две главные компоненты, полученные методом PCA, содержат практически всю
 информацию о разбросе исходных данных.
 """
# Инициализация и применение метода PCA
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X)

# Вывод объясненной дисперсии
print("Объясненная дисперсия двух главных компонент:", sum(pca.explained_variance_ratio_))

print("=============================== Задание 6 ===============================")
plt.figure(figsize=(8, 6))
plt.scatter(X_pca[:, 0], X_pca[:, 1], c=y, cmap='viridis')
plt.xlabel('Главная компонента 1')
plt.ylabel('Главная компонента 2')
plt.title('Визуализация данных по двум главным компонентам')
plt.colorbar(label='Класс')
plt.show()

print("=============================== Задание 7 ===============================")
X_train_pca, X_test_pca, y_train, y_test = train_test_split(X_pca, y, test_size=0.2, random_state=42)

rf_classifier_pca = RandomForestClassifier()
start_time = time.time()
rf_classifier_pca.fit(X_train_pca, y_train)
end_time = time.time()

y_pred_pca = rf_classifier_pca.predict(X_test_pca)

accuracy_pca = accuracy_score(y_test, y_pred_pca)
print("Точность модели случайного леса на данных PCA:", accuracy_pca)

print("Время обучения модели (в секундах):", end_time - start_time)

print("=============================== Задание 8 ===============================")
pca_original = PCA()
pca_original.fit(X)

cumulative_explained_variance_ratio = np.cumsum(pca_original.explained_variance_ratio_)

n_components_90 = np.argmax(cumulative_explained_variance_ratio >= 0.9) + 1
print("Количество главных компонент для сохранения 90% дисперсии:", n_components_90)

pca_90 = PCA(n_components=n_components_90)
X_pca_90 = pca_90.fit_transform(X)


print("=============================== Задание 9 ===============================")
X_train_pca_90, X_test_pca_90, y_train, y_test = train_test_split(X_pca_90, y, test_size=0.2, random_state=42)

rf_classifier_pca_90 = RandomForestClassifier()
start_time = time.time()
rf_classifier_pca_90.fit(X_train_pca_90, y_train)
end_time = time.time()

y_pred_pca_90 = rf_classifier_pca_90.predict(X_test_pca_90)

accuracy_pca_90 = accuracy_score(y_test, y_pred_pca_90)
print("Точность модели случайного леса на данных PCA с 90% дисперсии:", accuracy_pca_90)

print("Время обучения модели (в секундах) на данных PCA с 90% дисперсии:", end_time - start_time)


"""
1) Уменьшение размерности в машинном обучении:
Уменьшение размерности означает уменьшение количества признаков 
(измерений) в наборе данных. Это позволяет упростить модель и избавиться 
от избыточных или неинформативных признаков.

2) Методы входящие в Feature Selection:
Методы Feature Selection выбирают наиболее важные признаки для модели. 
К ним относятся Filter Methods, Wrapper Methods и Embedded Methods. 
Filter Methods оценивают признаки независимо от модели. 
Wrapper Methods используют конкретную модель для оценки качества подмножества признаков.
Embedded Methods включают отбор признаков в процессе обучения модели.

3) Принцип работы метода PCA:
Метод главных компонент (PCA) находит новые ортогональные оси в 
пространстве признаков, которые максимально сохраняют дисперсию данных. 
Он проецирует исходные данные на эти новые оси, уменьшая размерность данных.

4) Понятие главная компонента:
Главные компоненты - это новые оси в пространстве признаков, полученные методом PCA. 
Они представляют собой линейные комбинации исходных признаков, обеспечивающие максимальный разброс данных.

5) Термин "Ансамбли" в машинном обучении:
Ансамбли - это методы, которые комбинируют прогнозы нескольких моделей 
для улучшения общей производительности. Они включают в себя методы стекинга, бэггинга и бустинга.

6) Работа алгоритмов стекинг, бэггинг и бустинг:
Стекинг: Обучает модель, которая использует прогнозы нескольких базовых моделей в качестве входных данных.
Бэггинг: Обучает несколько моделей на разных подмножествах обучающих данных и усредняет их прогнозы.
Бустинг: Строит последовательность моделей, каждая из которых исправляет ошибки предыдущей модели.

7) Метод Random Forest:
Random Forest - это ансамбль деревьев решений, где каждое дерево 
строится независимо на случайной подвыборке обучающих данных, а затем 
прогнозы агрегируются для получения итогового результата. 
В Random Forest используется алгоритм бэггинга.
"""
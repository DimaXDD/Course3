import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import pydotplus

table = pd.read_csv("heart.csv")
print(table.head())


# =============================== Задание 1(а) ===============================
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, precision_score, recall_score, confusion_matrix

# Предсказываем столбец "target"
X = table.drop('target', axis=1)
y = table['target']

# Обучающий и тестовый набор
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = LogisticRegression()
model.fit(X_train, y_train)

# Точность на обучающих и тестовых данных
print("Правильность на обучающем наборе: {:.2f}".format(model.score(X_train, y_train)))
print("Правильность на тестовом наборе: {:.2f}".format(model.score(X_test, y_test)))

# =============================== Задание 1(б) ===============================
for C in [100, 0.01]:
    model = LogisticRegression(C=C)
    model.fit(X_train, y_train)
    print(f"\nПри C={C}:")
    print("Правильность на обучающем наборе: {:.2f}".format(model.score(X_train, y_train)))
    print("Правильность на тестовом наборе: {:.2f}".format(model.score(X_test, y_test)))

# =============================== Задание 1(в) ===============================
# Добавление в модель L2-регуляризации
model = LogisticRegression(penalty='l2', C=0.1)
model.fit(X_train, y_train)

# Метрики качества и матрицу ошибок для модели
y_pred = model.predict(X_test)
print("\nМетрики качества для модели с L2-регуляризацией и C=0.1:")
print("Точность: {:.2f}".format(accuracy_score(y_test, y_pred)))
print("Полнота: {:.2f}".format(recall_score(y_test, y_pred)))
print("Точность: {:.2f}".format(precision_score(y_test, y_pred)))
print("Матрица ошибок:")
print(confusion_matrix(y_test, y_pred))

# =============================== Задание 2(а) ===============================
from sklearn.svm import SVC
from sklearn.model_selection import GridSearchCV

# Модель метода опорных векторов
model_SVC = SVC()
model_SVC.fit(X_train, y_train)

# Точность на обучающих и тестовых данных
print("Правильность на обучающем наборе: {:.2f}".format(model_SVC.score(X_train, y_train)))
print("Правильность на тестовом наборе: {:.2f}".format(model_SVC.score(X_test, y_test)))

# =============================== Задание 2(б) ===============================
# GridSearchCV для нахождения наилучших параметров С и гамма
SVC_params = {"C": [0.1, 1, 10], "gamma": [0.2,0.6, 1]}
SVC_grid = GridSearchCV(model_SVC, SVC_params, cv=5, n_jobs=-1)
SVC_grid.fit(X_train, y_train)

print("Наилучший результат GridSearchCV: {:.2f}".format(SVC_grid.best_score_))
print("Наилучшие параметры: ", SVC_grid.best_params_)

# Модель с наилучшими параметрами
best_model = SVC(**SVC_grid.best_params_)
best_model.fit(X_train, y_train)

# =============================== Задание 2(в) ===============================
# Точность этой модели на обучающих и тестовых данных
print("\nПравильность на обучающем наборе: {:.2f}".format(best_model.score(X_train, y_train)))
print("Правильность на тестовом наборе: {:.2f}".format(best_model.score(X_test, y_test)))

# =============================== Задание 2(г) ===============================
# Метрики качества и матрицу ошибок для наилучшей модели
y_pred = best_model.predict(X_test)
print("\nМетрики качества для наилучшей модели SVC:")
print("Точность: {:.2f}".format(accuracy_score(y_test, y_pred)))
print("Полнота: {:.2f}".format(recall_score(y_test, y_pred)))
print("Точность: {:.2f}".format(precision_score(y_test, y_pred)))
print("Матрица ошибок:")
print(confusion_matrix(y_test, y_pred))

# =============================== Задание 3 ===============================
from sklearn.tree import DecisionTreeClassifier
# Модель дерева решений
model_tree = DecisionTreeClassifier()
model_tree.fit(X_train, y_train)

# Точность на обучающих и тестовых данных
print("Правильность на обучающем наборе (дерево решений): {:.2f}".format(model_tree.score(X_train, y_train)))
print("Правильность на тестовом наборе (дерево решений): {:.2f}".format(model_tree.score(X_test, y_test)))

# Модель K-ближайших соседей
from sklearn.neighbors import KNeighborsClassifier
model_knn = KNeighborsClassifier()
model_knn.fit(X_train, y_train)

# Рассчитайте точность на обучающих и тестовых данных
print("Правильность на обучающем наборе (K-ближайших соседей): {:.2f}".format(model_knn.score(X_train, y_train)))
print("Правильность на тестовом наборе (K-ближайших соседей): {:.2f}".format(model_knn.score(X_test, y_test)))

# =============================== Задание 4 ===============================
from sklearn.metrics import RocCurveDisplay
# Объекты для отображения ROC-кривых
ax = plt.gca()
# Для модели логистической регрессии
lr_disp = RocCurveDisplay.from_estimator(model, X_test, y_test, ax=ax, name='Logistic Regression')
# Для модели метода опорных векторов
svc_disp = RocCurveDisplay.from_estimator(best_model, X_test, y_test, ax=ax, name='SVC')
# Для модели дерева решений
dt_disp = RocCurveDisplay.from_estimator(model_tree, X_test, y_test, ax=ax, name='Decision Tree')
# Для модели K-ближайших соседей
knn_disp = RocCurveDisplay.from_estimator(model_knn, X_test, y_test, ax=ax, name='KNN')

plt.show()
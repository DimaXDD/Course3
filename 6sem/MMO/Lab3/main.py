import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import pydotplus

# =============================== Задание 1 ===============================
table = pd.read_csv("heart.csv")
print(table.head())

# =============================== Задание 2 ===============================
# Проверка на наличие нулевых значений
print(table.isnull().any())

# =============================== Задание 3 ===============================
# Y это массив меток (классов)
y = table["target"].astype("string")
X = table.drop("target", axis=1)
print(X.head())

print(y.head())

# =============================== Задание 4 ===============================
from sklearn.model_selection import cross_val_score, train_test_split

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=17)

print("Inputs X (train/test):", X_train.shape, X_test.shape)
print("Outputs Y (train/test):", y_train.shape, y_test.shape)

# =============================== Задание 5 ===============================
from sklearn.tree import DecisionTreeClassifier

tree = DecisionTreeClassifier(random_state=0)

tree.fit(X_train, y_train)

print("Правильность на обучающем наборе (дерево решений): {:.3f}".format(tree.score(X_train, y_train)))
print("Правильность на тестовом наборе (дерево решений): {:.3f}".format(tree.score(X_test, y_test)))


from sklearn.neighbors import KNeighborsClassifier

# Создаем модель k-ближайших соседей
knn = KNeighborsClassifier(n_neighbors=8)

# Обучаем модель на обучающем наборе
knn.fit(X_train, y_train)

# Рассчитываем точность модели на обучающем и тестовом наборах
print("Правильность на обучающем наборе (k-ближайших): {:.3f}".format(knn.score(X_train, y_train)))
print("Правильность на тестовом наборе (k-ближайших): {:.3f}".format(knn.score(X_test, y_test)))


# =============================== Задание 6 ===============================
from sklearn.model_selection import GridSearchCV

# Для дерева решений
param_grid_tree = {'max_depth': range(1, 10)}
grid_search_tree = GridSearchCV(DecisionTreeClassifier(random_state=0), param_grid_tree, cv=5)
grid_search_tree.fit(X_train, y_train)

print("Наилучшие параметры дерева решений: {}".format(grid_search_tree.best_params_))
print("Наилучшая оценка дерева решений: {:.3f}".format(grid_search_tree.best_score_))

# Для k-ближайших соседей
param_grid_knn = {'n_neighbors': range(1, 10)}
grid_search_knn = GridSearchCV(KNeighborsClassifier(), param_grid_knn, cv=5)
grid_search_knn.fit(X_train, y_train)

print("Наилучшие параметры k-ближайших соседей: {}".format(grid_search_knn.best_params_))
print("Наилучшая оценка k-ближайших соседей: {:.3f}".format(grid_search_knn.best_score_))

print("-------------Prediction------------")

tree_valid_pred = tree.predict(X_test) # прогноз на отложенной выборке
print(y_test.head(10))
print(tree_valid_pred[0:10]) # первые 10 спрогнозированых меток

from sklearn.metrics import confusion_matrix

# =============================== Задание 7 ===============================
# Для дерева решений
tree_pred = tree.predict(X_test)
tree_cm = confusion_matrix(y_test, tree_pred)
print("Матрица ошибок для дерева решений:\n", tree_cm)

# Для k-ближайших соседей
knn_pred = knn.predict(X_test)
knn_cm = confusion_matrix(y_test, knn_pred)
print("Матрица ошибок для k-ближайших соседей:\n", knn_cm)

# =============================== Задание 8 ===============================
# Выбор лучшей модели
best_model = grid_search_tree if grid_search_tree.best_score_ > grid_search_knn.best_score_ else grid_search_knn
print("Лучшая модель: ", type(best_model.best_estimator_).__name__)


# =============================== Задание 9 ===============================
from sklearn.tree import plot_tree
# Уменьшаем глубину дерева для визуализации
tree_viz = DecisionTreeClassifier(max_depth=3, random_state=0)
tree_viz.fit(X_train, y_train)

plt.figure(figsize=(12, 8))
plot_tree(tree_viz, filled=True, feature_names=X.columns, class_names=['0', '1'], proportion=True)
plt.show()

fig, ax = plt.subplots(figsize=(12, 8))
plot_tree(tree_viz, filled=True, feature_names=X.columns, class_names=['0', '1'], proportion=True, ax=ax)
fig.savefig('tree.png')

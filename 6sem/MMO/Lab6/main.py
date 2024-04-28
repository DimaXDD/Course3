import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.preprocessing import MinMaxScaler
from sklearn.cluster import KMeans, AgglomerativeClustering
from sklearn.metrics import silhouette_score
from scipy.cluster import hierarchy
import warnings
warnings.filterwarnings("ignore")


print("=============================== Задание 1 ===============================")
data = pd.read_csv('Mall_Customers.csv')
print(data.head())
X = data.iloc[:, [3, 4]].values  # Используем несколько параметров

print("=============================== Задание 2 ===============================")
missing_values = np.isnan(X).sum()
print("Пропущенные значения в X:")
print(missing_values)

# Если в X есть категориальные данные, их можно закодировать с помощью различных методов,
# например, методом One-Hot Encoding или Label Encoding.
# Но в данном случае, поскольку X содержит только числовые столбцы (3 и 4),
# кодирование категориальных данных не требуется.

print("=============================== Задание 3 ===============================")
scaler = MinMaxScaler()
X_scaled = scaler.fit_transform(X)

print("=============================== Задание 4 ===============================")
inertia = []
for n_clusters in range(1, 11):
    kmeans = KMeans(n_clusters=n_clusters, random_state=42)
    kmeans.fit(X_scaled)
    inertia.append(kmeans.inertia_)

plt.figure(figsize=(10, 6))
plt.plot(range(1, 11), inertia, marker='o')
plt.xlabel('Number of clusters')
plt.ylabel('Inertia')
plt.title('Elbow Method (Задание 4)')
plt.show()

# Из графика видно, что "локоть" находится при количестве кластеров равном 5
kmeans = KMeans(n_clusters=5, random_state=42)
kmeans_labels = kmeans.fit_predict(X_scaled)

print("=============================== Задание 5 ===============================")
plt.figure(figsize=(10, 6))
plt.scatter(X_scaled[:, 0], X_scaled[:, 1], c=kmeans_labels, cmap='viridis')
plt.title('K-means Clustering (Задание 5)')
plt.xlabel('Annual Income (scaled)')
plt.ylabel('Spending Score (scaled)')
plt.colorbar(label='Cluster')
plt.show()

print("=============================== Задание 6 ===============================")
hc = AgglomerativeClustering(n_clusters=5)
hc_labels = hc.fit_predict(X_scaled)


plt.figure(figsize=(10, 6))
dendrogram = hierarchy.dendrogram(hierarchy.linkage(X_scaled, method='ward'))
plt.title('Dendrogram (Задание 6)')
plt.xlabel('Samples')
plt.ylabel('Distance')
plt.show()

print("=============================== Задание 7 ===============================")
plt.figure(figsize=(10, 6))
plt.scatter(X_scaled[:, 0], X_scaled[:, 1], c=hc_labels, cmap='viridis')
plt.title('Hierarchical Clustering (Задание 7)')
plt.xlabel('Annual Income (scaled)')
plt.ylabel('Spending Score (scaled)')
plt.colorbar(label='Cluster')
plt.show()

print("=============================== Задание 8 ===============================")
silhouette_kmeans = silhouette_score(X_scaled, kmeans_labels)
silhouette_hc = silhouette_score(X_scaled, hc_labels)
print(f"Silhouette Score (K-means): {silhouette_kmeans}")
print(f"Silhouette Score (Hierarchical Clustering): {silhouette_hc}")

print("=============================== Задание 9 ===============================")
chosen_index = 0  # Для примера выберем первого
plt.figure(figsize=(10, 6))
plt.scatter(X_scaled[:, 0], X_scaled[:, 1], c=hc_labels, cmap='viridis')
plt.scatter(X_scaled[chosen_index, 0], X_scaled[chosen_index, 1], c='red', s=100, label='Chosen Object')
plt.title('Hierarchical Clustering with Chosen Object (Задание 9)')
plt.xlabel('Annual Income (scaled)')
plt.ylabel('Spending Score (scaled)')
plt.colorbar(label='Cluster')
plt.legend()
plt.show()


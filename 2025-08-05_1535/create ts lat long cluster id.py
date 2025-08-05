#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Aug  5 14:00:23 2025

@author: rcole
"""


import pandas as pd
import numpy as np
from sklearn.cluster import DBSCAN
from geopy.distance import great_circle
from shapely.geometry import MultiPoint
import matplotlib.pyplot as plt

# -----------------------
# Load dataset
# -----------------------
# Replace with your CSV filename
df = pd.read_csv(r'/Users/rcole/Desktop/imacgration/Misc Files/synthetic_movement_dataset_anomalous.csv')

# Ensure columns are properly named
df.columns = [col.strip().lower() for col in df.columns]

# Extract coordinates
coords = df[['latitude', 'longitude']].to_numpy()

# -----------------------
# Define DBSCAN parameters
# -----------------------
# eps: distance in kilometers, min_samples: number of points to form a cluster
kms_per_radian = 6371.0088
epsilon = 0.5 / kms_per_radian  # 0.5 km radius

db = DBSCAN(eps=epsilon, min_samples=10, algorithm='ball_tree', metric='haversine').fit(
    np.radians(coords)
)
cluster_labels = db.labels_
num_clusters = len(set(cluster_labels) - {-1})


#print(f'Number of clusters found: {num_clusters}')
#df['cluster'] = cluster_labels

df_result = pd.DataFrame({'id' : list(df['id']), 'cluster_id' : list(db.labels_)})
df_result.to_csv(r'/Users/rcole/Desktop/imacgration/Misc Files/geosb ts lat long cluster.csv', index=False)


'''
# -----------------------
# Identify cluster centroids
# -----------------------
clusters = pd.DataFrame(columns=['cluster_id', 'latitude', 'longitude', 'num_points'])
'''

'''
for cluster_id in set(cluster_labels):
    if cluster_id != -1:  # Ignore noise
        cluster_points = coords[cluster_labels == cluster_id]
        centroid = MultiPoint(cluster_points).centroid
        clusters = pd.concat([
            clusters,
            pd.DataFrame([{
                'cluster_id': cluster_id,
                'latitude': centroid.y,
                'longitude': centroid.x,
                'num_points': len(cluster_points)
            }])
        ], ignore_index=True)
'''



#print("\nCluster Centers:")
#print(clusters)

#clusters.to_csv(r'/Users/rcole/Desktop/imacgration/Misc Files/geosb clusters.csv')


# -----------------------
# Plot results
# -----------------------
'''
plt.figure(figsize=(10, 8))
colors = plt.cm.get_cmap('tab10', num_clusters)

for cluster_id in set(cluster_labels):
    cluster_points = coords[cluster_labels == cluster_id]
    if cluster_id == -1:
        # Plot noise (anomalies)
        plt.scatter(cluster_points[:, 1], cluster_points[:, 0], c='k', marker='x', label='Anomalies')
    else:
        plt.scatter(cluster_points[:, 1], cluster_points[:, 0], label=f'Cluster {cluster_id}')

plt.title('DBSCAN Clustering of Movement Data (Weston, FL)')
plt.xlabel('Longitude')
plt.ylabel('Latitude')
plt.legend()
plt.show()
'''

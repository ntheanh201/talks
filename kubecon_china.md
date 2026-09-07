---
theme: kubecon_china
seaborn_theme: kubecon_china
title: Accelerating AI on Kubernetes with HAMi
footer: Accelerating AI on Kubernetes with HAMi - KubeCon + CloudNativeCon China 2026
logo: assets/brand/dynamia-logo.svg
logo_dark: assets/brand/dynamia-logo-white.png
watermark: assets/brand/kubecon_china/watermark.svg
transition: fade
paginate: true
---

@variant dark
@kicker KubeCon + CloudNativeCon China 2026
# Accelerating AI on Kubernetes with HAMi

@subtitle Slicing one GPU, running many workloads

@speaker name="Reza Jelveh" role="Solution Architect, Dynamia AI - Makers of HAMi" github=github.com/fishman linkedin=linkedin.com/in/rezajelveh

---

## Why share GPUs at all

@subtitle GPUs are too expensive to give one workload the whole card

<!--
GPUs are the most expensive resource in the cluster, and most AI workloads use a fraction of one. Sharing lets many small jobs fit on one physical device.
-->

- A single GPU costs more than most nodes
- Training, inference, and batch jobs rarely fill a whole device
- Sharing raises utilization without buying more hardware

::: grid {cols=3}
::: card {metric}
3-5x
More workloads per device
:::
::: card {metric}
1MB
Granular memory slicing
:::
::: card {metric}
0
Code changes required
:::
:::

---

## Hard isolation on shared devices

@subtitle Memory and compute caps enforced on every CUDA call

::: grid {cols=2}
::: card {tag=green}
### {icon:shield-check cls=accent-primary} Hard limits

Every allocation checked against the pod's slice. Memory and compute caps enforced in-process.
:::
::: card {tag=cyan}
### {icon:layers cls=accent-secondary} Fine-grained slicing

As small as 1MB of device memory and 1% of compute cores.
:::
::: card {tag=yellow}
### {icon:git-branch cls=accent-secondary} Smart scheduling

Binpack, spread, and topology-aware placement keep whole cards free for big models.
:::
::: card {tag=red}
### {icon:triangle-alert cls=accent-primary} No OOM storms

A greedy pod can no longer evict everyone else on the card.
:::
:::

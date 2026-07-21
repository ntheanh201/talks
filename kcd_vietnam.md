---
theme: kcd_vietnam
title: HAMi Introduction
footer: HAMi - Heterogeneous AI Computing Virtualization Middleware
paginate: true
---

@variant dark
@kicker A CNCF Incubation Project

# HAMi

@subtitle Heterogeneous AI Computing Virtualization Middleware<br>Unified Management, Efficient Scheduling, Maximizing GPU Utilization

---

## The GPU Challenge

@subtitle Supply and demand are polarized

::: grid {cols=2}
::: card {tag=red}
### Supply Side

- Many GPU manufacturers (NVIDIA, AMD, Intel, Huawei Ascend)
- Specifications vary widely
- Centralized management is difficult
- Resource scheduling is rough
:::
::: card {tag=yellow}
### Demand Side

- GPU resources are scarce
- Users are cost-sensitive
- Inference demands are fragmented
- Utilization is often low
:::
:::

---

## GPU Management Pain Points

- {icon:server cls=accent-secondary} No resource pool, no overall scheduling, no management plane
- {icon:layers cls=accent-secondary} GPUs scattered, difficult to manage centrally
- {icon:lock cls=accent-secondary} No GPU sharing - 1 GPU per task minimum
- {icon:chart-bar cls=accent-secondary} Resource allocation is inflexible, cannot specify size/type
- {icon:triangle-alert cls=accent-secondary} No GPU over-division, wasted capacity

---

## What is HAMi

Heterogeneous AI Computing Virtualization Middleware

- {icon:zap cls=accent-primary} Pluggable, lightweight, deploys in any Kubernetes environment
- {icon:layers cls=accent-primary} Virtualizes heterogeneous AI chips (NVIDIA, Ascend, Cambricon, Hygon, Iluvatar)
- {icon:share cls=accent-primary} GPU sharing - multiple tasks share one GPU
- {icon:settings-2 cls=accent-primary} Rich scheduling strategies: binpack, spread, priority, topology-aware
- {icon:shield-check cls=accent-primary} CNCF Sandbox project, 80+ contributors, 100+ enterprise adopters

---

## HAMi Community

| Metric | Value |
|--------|-------|
| Contributors | 80+ |
| Enterprise adopters | 100+ |
| CNCF Status | Sandbox + CNAI Landscape |
| Focus | AI Infra + Heterogeneous AI Management |

The only open-source project focused on AI Infrastructure and heterogeneous AI management in CNCF.

---

## GPU Sharing

@subtitle Dynamic fine-grained device slicing

- **All NVIDIA series** supported
- **Fine-grained:** as small as 1MB device memory, 1% computing cores
- **Transparent to tasks** - no code changes required
- **Hard resource isolation** inside containers

HAMi provides device sharing by dynamic device slicing. A task allocates a portion of GPU, leaving the rest for other tasks.

---

## How GPU Sharing Works

HAMi-Core uses **symbolic hijacking** inside containers:

| Requirement | Specification |
|-------------|---------------|
| NVIDIA driver | >= 440 |
| CUDA | >= 10.2 |
| Device Memory isolation | Yes |
| Core utilization limit | Yes |
| Fault isolation | Yes |
| Transparent to GPU tasks | Yes |


---

## GPU Utilization Impact

HAMi enables elastic GPU memory scaling -- idle tasks swap to host RAM, freeing device memory for active workloads:

```seaborn
import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(8, 2.8))

fg = plt.rcParams["text.color"]
dimmed = plt.rcParams["xtick.color"]
cmap = plt.get_cmap("Paired")
danger = cmap(4.5 / 12)
danger_bright = cmap(5 / 12)
elastic = cmap(2.5 / 12)
base = cmap(0.5 / 12)
ax.set_facecolor("none")
fig.patch.set_alpha(0)

ax.barh(1, 8, color=base, height=0.65)
ax.barh(1, 3, left=8, color=danger, height=0.65)
ax.plot([10, 10], [0.62, 1.38], color=danger, linewidth=2.5, solid_capstyle="butt")

ax.barh(0, 8, color=base, height=0.65)
ax.barh(0, 7, left=8, color=elastic, height=0.65)
ax.plot([10, 10], [-0.38, 0.38], color=fg, linewidth=1.5, linestyle="--")
ax.plot([15, 15], [-0.38, 0.38], color=fg, linewidth=1.5, linestyle="--")

ax.set_xlim(0, 15.2)
ax.spines[["top", "right", "left", "bottom"]].set_visible(False)
ax.tick_params(left=False, bottom=False, labelleft=False, labelbottom=False)

ax.text(-0.3, 1, "Without HAMi", ha="right", va="center", fontsize=10, color=fg, fontweight="bold")
ax.text(-0.3, 0, "With HAMi:\nElastic Scaling", ha="right", va="center", fontsize=10, color=fg, fontweight="bold")

ax.text(4, 1, "Normal base load", ha="center", va="center", fontsize=9, color=fg, fontweight="bold")
ax.text(9.5, 1, "Traffic spike", ha="center", va="center", fontsize=7.5, color=dimmed, fontweight="bold")
ax.text(10, 1.42, "10 GB limit", ha="center", va="bottom", fontsize=8, color=danger_bright, fontweight="bold")

ax.text(4, 0, "Normal base load", ha="center", va="center", fontsize=9, color=fg, fontweight="bold")
ax.text(11.5, 0, "Traffic spike", ha="center", va="center", fontsize=7.5, color=dimmed, fontweight="bold")
ax.text(10, 0.38, "10 GB\nsoft limit", ha="center", va="bottom", fontsize=7.5, color=dimmed)
ax.text(15, 0.38, "15 GB\nburst", ha="center", va="bottom", fontsize=7.5, color=dimmed)
```


---

## GPU Sharing Parameters



- : memory size per GPU. Defaults to all available if not set
- : compute percentage per GPU. 0-100 range.

---

## Specify Device Type

HAMi supports targeting or avoiding specific GPU models:



Schedule tasks to specific GPU models or avoid certain types entirely.

---

## Scheduling Policies

::: grid {cols=2}
::: card {tag=cyan}
### {icon:arrow-up cls=accent-primary} Priority-based

High-priority pods pause lower-priority tasks. Set via  env var.
:::
::: card {tag=green}
### {icon:gauge cls=accent-contrast} Binpack & Spread

Binpack minimizes fragments. Spread distributes evenly across nodes/devices.

![Binpack vs Spread scheduling](assets/hami_intro/binpack_spread.png)
:::
:::

::: grid {cols=2}
::: card {tag=yellow}
### {icon:git-branch cls=accent-contrast} Topology-aware

NVLink-aware scheduling for multi-GPU efficiency. 25GB/s-1800GB/s vs PCIe 16GB/s.

![NUMA topology-aware scheduling](assets/hami_intro/topology_numa.png)
:::
::: card {tag=cyan}
### {icon:crosshair cls=accent-primary} Device-specific

Specify exact GPU models or specific device UUIDs for task placement.
:::
:::

---

## Memory Oversubscription

@layout compare

::: card {tag=compare}
### Before

23GB Device Memory hosts **1** 13B inference model
:::

::: arrow

{icon:arrow-right cls=accent-primary size=48}
:::

::: card {tag=compare}
### After

23GB Device + 46GB virtual memory hosts **3** 13B inference models
:::

GPU memory automatically swapped to host RAM for idle tasks. Typical scenario: model loading and inference serving.

---

## Observability

HAMi provides built-in monitoring dashboards (Grafana + Prometheus):

- **K8s scheduling dimension:** vGPU task bindings, task-to-GPU relationships
- **GPU device dimension:** real computing power and memory usage during runtime
- Community best-practice monitoring dashboard included

---

## HAMi vs Other Projects

| Feature | HAMi | NVIDIA device-plugin | NVIDIA DRA driver |
|---------|:---:|:---:|:---:|
| Multi-vendor GPUs | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} |
| GPU sharing | {icon:check cls=accent-primary} | {icon:check cls=accent-primary} | {icon:check cls=accent-primary} |
| Flexible scheduling | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} |
| Dynamic MIG | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} |
| Memory oversubscription | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} |
| Topology-aware | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} |
| Heterogeneous devices | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} |

---

## GPU Sharing Methods Compared

| Method | Multi-vendor | Isolation | Fragmentation | Overhead |
|--------|:---:|:---:|:---:|:---:|
| HAMi vGPU | {icon:check cls=accent-primary} | Strong | Low | Low |
| CUDA Streams | {icon:x cls=accent-secondary} | Weak | High | Low |
| MPS | {icon:x cls=accent-secondary} | Medium | Low | Medium |
| Time-slicing | {icon:x cls=accent-secondary} | Weak | High | Low |
| MIG | {icon:x cls=accent-secondary} | Strong | High | N/A |
| NVIDIA vGPU | {icon:x cls=accent-secondary} | Strong | Low | High |

---

## Applicable Scenarios

::: grid {cols=2}
::: card {tag=green}
### {icon:globe cls=accent-primary} Online Inference

10 services share one GPU. Activate on-demand, low-frequency services share resources. Significantly reduces GPU costs.
:::
::: card {tag=cyan}
### {icon:git-compare-arrows cls=accent-contrast} A/B Testing

Virtual GPU memory reduces hardware requirements. Original + experimental models share a single GPU.
:::
:::

::: grid {cols=2}
::: card {tag=yellow}
### {icon:refresh-cw cls=accent-contrast} Mixed Train/Infer

Inference gets priority, training fills gaps. When inference idle, cached training runs. Flexible queue-based scheduling.
:::
::: card {tag=cyan}
### {icon:zap cls=accent-primary} LLM Optimization

Multiple small models (embedding, reranker, generator) share GPUs. 4 threads → 8 threads on same hardware.
:::
:::

---

## Ecosystem Integrations

| Project | Integration |
|---------|-------------|
| Volcano | Batch scheduling for HPC/AI workloads (CNCF) |
| Koordinator | Colocation of microservices, AI, big data |
| KEDA | Event-driven autoscaling |
| Prometheus + Grafana | Monitoring and observability |
| Helm | One-command deployment |

---

## About HAMi

- {icon:git-fork cls=accent-primary} github.com/Project-HAMi/HAMi
- {icon:globe cls=accent-primary} project-hami.io
- {icon:users cls=accent-primary} 80+ contributors, 100+ enterprise adopters
- {icon:shield-check cls=accent-primary} CNCF Sandbox Project

Community edition is free and open-source. Enterprise edition available with additional features and support.

---

@kicker Thank You

# Questions?

@speaker name="Reza Jelveh" role="Solution Architect, Dynamia AI  -  Makers of HAMi" github=github.com/rezajelveh twitter=@rezajelveh
@speaker name="Anh Nguyen" role="Solutions Engineer, Viettel"

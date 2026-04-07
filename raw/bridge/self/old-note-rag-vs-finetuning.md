# RAG vs Fine-tuning — quick note

Written: sometime in early 2025, cleaning up old notes

RAG = Retrieval Augmented Generation. You keep a doc store, retrieve relevant chunks at query time, stuff them in context. No training. Good for frequently changing data.

Fine-tuning = you retrain the model weights on your data. The knowledge is "baked in". Expensive, slow to update, good for style/format.

When to use which:
- RAG: data changes often, need citations, can't afford training
- Fine-tuning: data is stable, need consistent output style, latency matters

Hybrid: fine-tune for style + RAG for facts. Best of both, most expensive.

Personally I think RAG gets over-used. For small-medium doc collections (<100 docs) just have the LLM read the files directly. Simpler, cheaper, easier to debug.

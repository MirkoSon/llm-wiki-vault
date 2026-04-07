# The Rise of LLM Agents: Patterns and Pitfalls

**Source**: Test article for wiki sandbox
**Date**: 2026-04-01

LLM agents are software systems that use large language models to plan and execute multi-step tasks. Unlike a simple chatbot, an agent can call tools, read files, search the web, and act on its findings.

## Key patterns

**ReAct (Reason + Act)** is the most common pattern. The agent alternates between reasoning about what to do next and taking an action. Each step is visible, making it easier to debug.

**Plan-and-execute** separates the planning phase from execution. A planner LLM generates a task list; an executor LLM carries it out. Better for long tasks but harder to recover from mid-plan failures.

**Multi-agent systems** divide work across specialized agents. One agent researches, another writes, a third reviews. Coordination overhead is significant but parallelism can speed things up.

## Common pitfalls

- **Tool call loops**: agents get stuck calling the same tool repeatedly
- **Context window exhaustion**: long tasks overflow the model's context
- **Hallucinated tool outputs**: model fabricates results rather than using real tools
- **Prompt injection**: malicious content in tool outputs hijacks the agent

## Key companies

**Anthropic** builds Claude, which powers Claude Code and Cowork. Known for Constitutional AI and safety focus.

**OpenAI** builds GPT-4 and the Codex/Assistants API. Pioneered many agent patterns.

**Google DeepMind** builds Gemini. Strong on multimodal tasks.

## Conclusion

Agent frameworks are converging on similar patterns. The differentiator is not the LLM itself but the quality of tool design, error recovery, and memory management.

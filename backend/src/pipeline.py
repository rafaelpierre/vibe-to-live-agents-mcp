from agents.mcp import MCPServerStdio
from datetime import datetime
from agents import Agent, Runner, function_tool


@function_tool
async def get_time() -> str:
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")


mcp_fetch = MCPServerStdio(params={"command": "uvx", "args": ["mcp-server-fetch"]})


async def run(prompt: str) -> str:
    async with mcp_fetch:
        agent = Agent(
            name="assistant",
            model="gpt-4.1-mini",
            mcp_servers=[mcp_fetch],
            tools=[get_time],
        )

        result = await Runner.run(
            agent,
            """
                You are a helpful assistant. Please look at the WHAT, WHY and HOW sections below to fulfill the user's request.
                ### WHAT
                    Please get the weather forecast for {prompt}.
                ### HOW
                    1. Fetch the data for this location from www.meteoblue.com website.
                    2. Get the current time.
                    3. Return the results as a bullet point list. Include a summary of the weather conditions, temperature, and any other relevant information.
                    4. If the weather is suitable for snowboarding, include a note about that.
                    5. If the weather is not suitable for snowboarding, include a note about that.
                
                ### WHY
                    I wanna go snowboarding, but only if conditions allow it.
            """.format(prompt=prompt),
        )

        return result.final_output

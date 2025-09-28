# Main Components Breakdown

## Global Layout & Theme

Theme: Minimalist, dark mode interface; background is a very dark gray/black.
Center Alignment: All core interactive elements are centered both vertically and horizontally within the viewport.
Whitespace: Generous whitespace, resulting in a clean, uncluttered look.

## Header Section

App Logo/Icon (Top-Left): a small snowflake icon.
App name ("GoSnow") in simple, sans-serif font.
Left-aligned at the top.


##  Main Interaction Area (Central Panel)

Structured as a div with 700px width, centered in the viewport.

### Title & Prompt

#### Title:

“Where do you wanna snowboard?” — Centered headline, medium-large font size, light color for contrast.

Add 30 px padding between the title and the input field.

#### Input Field:

#### Text Input: Centered, horizontally long, rounded corners, placeholder text (“Jay Peak, VT”).

#### Submit Button: Small, cyan, circular, right arrow icon (↗) for submission, positioned to the right of the input field.

Add 20px padding between the input field and suggested questions.

### Suggested Questions

List of Example Queries:

4 items, each starts with a right-up arrow icon (↗).

Light color for text, subtle hover effect expected.

Examples are short (“Jay Peak, VT”, "Les Deux, France" etc.).

Vertically stacked, left-aligned within the central box.

### Styling & Branding Notes

#### Font: Modern, geometric sans-serif (think Inter, Helvetica Neue, or similar).

#### Colors:

- Background: #181A20 (approximate).
- Text: Mostly white/very light gray.
- Accent: Cyan for icons/arrows and toggles.
- Icons: Simple, line-based.


### Frontend Engineering Recommendations

This project uses **Vite, React and Typescript**!

#### Componentize:

- Header (Logo + Utility Icons)
- Central Interaction Box (Title, Input Field, Mode/Toggle, Suggestions)
- Use flexbox/grid for centering and responsive alignment.
- Icon Library: Use a consistent set (e.g., Lucide).


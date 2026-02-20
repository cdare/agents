---
name: design
description: "Use when building dashboards, SaaS UIs, admin interfaces, or any interface needing polished professional design. Covers design direction, craft principles, and 9-phase implementation. Triggers on: 'use design mode', 'design system', 'design system upgrade'. Full access mode."

cc:
  allowed-tools: [Read, Edit, Write, Bash, Grep, Glob, WebFetch, WebSearch, LSP]
---

# Premium UI Design & Implementation

A comprehensive guide to premium UI design and implementation. Part 1 establishes design direction, Part 2 covers craft principles, and Part 3 provides the 9-phase implementation approach.

---

## Part 1: Design Direction (REQUIRED)

Before writing any code, commit to a design direction. Don't default. Think about what this specific product needs to feel like.

### Think About Context

- **What does this product do?** A finance tool needs different energy than a creative tool.
- **Who uses it?** Power users want density. Occasional users want guidance.
- **What's the emotional job?** Trust? Efficiency? Delight? Focus?
- **What would make this memorable?** Every product has a chance to feel distinctive.

### Choose a Personality

Enterprise/SaaS UI has more range than you think:

| Personality                  | Characteristics                                    | Examples                        |
| ---------------------------- | -------------------------------------------------- | ------------------------------- |
| **Precision & Density**      | Tight spacing, monochrome, information-forward     | Linear, Raycast, terminal tools |
| **Warmth & Approachability** | Generous spacing, soft shadows, friendly colors    | Notion, Coda                    |
| **Sophistication & Trust**   | Cool tones, layered depth, financial gravitas      | Stripe, Mercury                 |
| **Boldness & Clarity**       | High contrast, dramatic negative space, confident  | Vercel                          |
| **Utility & Function**       | Muted palette, functional density, clear hierarchy | GitHub, developer tools         |
| **Data & Analysis**          | Chart-optimized, technical but accessible          | Analytics, BI tools             |

Pick one. Or blend two. But commit.

#### Personality → Implementation Mapping

| Personality              | Border Radius | Shadows      | Spacing | Colors        |
| ------------------------ | ------------- | ------------ | ------- | ------------- |
| Precision & Density      | 4-6px         | Borders only | 8-12px  | Monochrome    |
| Warmth & Approachability | 12-16px       | Soft shadows | 16-24px | Warm neutrals |
| Sophistication & Trust   | 8-12px        | Layered      | 16-20px | Cool slate    |
| Boldness & Clarity       | 8px           | Dramatic     | 24-32px | Pure B&W      |
| Utility & Function       | 4-6px         | Minimal      | 8-12px  | Muted palette |
| Data & Analysis          | 6-8px         | Subtle       | 12-16px | Chart-ready   |

Use these as starting points—adapt to your specific context.

### Choose a Color Foundation

Don't default to warm neutrals. Consider the product:

- **Warm foundations** (creams, warm grays) — approachable, comfortable, human
- **Cool foundations** (slate, blue-gray) — professional, trustworthy, serious
- **Pure neutrals** (true grays, black/white) — minimal, bold, technical
- **Tinted foundations** (slight color cast) — distinctive, memorable, branded

**Light or dark?** Dark feels technical, focused, premium. Light feels open, approachable, clean.

**Accent color** — Pick ONE that means something. Blue for trust. Green for growth. Orange for energy. Violet for creativity.

### Choose a Layout Approach

The content should drive the layout:

- **Dense grids** for information-heavy interfaces where users scan and compare
- **Generous spacing** for focused tasks where users need to concentrate
- **Sidebar navigation** for multi-section apps with many destinations
- **Top navigation** for simpler tools with fewer sections
- **Split panels** for list-detail patterns where context matters

### Choose Typography

- **System fonts** — fast, native, invisible (utility-focused products)
- **Geometric sans** (Geist, Inter) — modern, clean, technical
- **Humanist sans** (SF Pro, Satoshi) — warmer, more approachable
- **Monospace influence** — technical, developer-focused, data-heavy

---

## Part 2: Core Craft Principles

These apply regardless of design direction. This is the quality floor.

### The 4px Grid

All spacing uses a 4px base grid:

| Value  | Usage                                 |
| ------ | ------------------------------------- |
| `4px`  | Micro spacing (icon gaps)             |
| `8px`  | Tight spacing (within components)     |
| `12px` | Standard spacing (related elements)   |
| `16px` | Comfortable spacing (section padding) |
| `24px` | Generous spacing (between sections)   |
| `32px` | Major separation                      |

### Symmetrical Padding

TLBR must match. If top padding is 16px, left/bottom/right must also be 16px.

```css
/* Good */
padding: 16px;
padding: 12px 16px; /* Only when horizontal needs more room */

/* Bad */
padding: 24px 16px 12px 16px;
```

### Border Radius Consistency

Stick to the 4px grid. Sharper corners feel technical, rounder corners feel friendly:

- **Sharp**: 4px, 6px, 8px
- **Soft**: 8px, 12px
- **Minimal**: 2px, 4px, 6px

Don't mix systems. Consistency creates coherence.

### Depth & Elevation Strategy

Match your depth approach to your design direction. Choose ONE:

**Borders-only (flat)** — Clean, technical, dense. Works for utility-focused tools. Linear, Raycast use almost no shadows—just subtle borders.

**Subtle single shadows** — Soft lift without complexity: `0 1px 3px rgba(0,0,0,0.08)`

**Layered shadows** — Rich, premium, dimensional. Stripe and Mercury use this approach.

**Surface color shifts** — Background tints establish hierarchy without shadows. A card at `#fff` on `#f8fafc` already feels elevated.

```css
/* Borders-only approach */
--border: rgba(0, 0, 0, 0.08);
border: 0.5px solid var(--border);

/* Single shadow approach */
--shadow: 0 1px 3px rgba(0, 0, 0, 0.08);

/* Layered shadow approach */
--shadow-layered:
  0 0 0 0.5px rgba(0, 0, 0, 0.05), 0 1px 2px rgba(0, 0, 0, 0.04),
  0 2px 4px rgba(0, 0, 0, 0.03), 0 4px 8px rgba(0, 0, 0, 0.02);
```

The craft is in the choice, not the complexity.

### Card Layouts

Monotonous card layouts are lazy design. A metric card doesn't have to look like a plan card doesn't have to look like a settings card.

Design each card's internal structure for its specific content—but keep the surface treatment consistent: same border weight, shadow depth, corner radius, padding scale, typography.

### Isolated Controls

UI controls deserve container treatment. Date pickers, filters, dropdowns should feel like crafted objects.

**Never use native form elements for styled UI.** Native `<select>`, `<input type="date">` render OS-native controls that cannot be styled. Build custom components instead.

Custom select triggers must use `display: inline-flex` with `white-space: nowrap` to keep text and chevron icons on the same row.

### Monospace for Data

Numbers, IDs, codes, timestamps belong in monospace. Use `tabular-nums` for columnar alignment. Mono signals "this is data."

### Iconography

Use **Phosphor Icons** (`@phosphor-icons/react`). Icons clarify, not decorate—if removing an icon loses no meaning, remove it.

Give standalone icons presence with subtle background containers.

### Contrast Hierarchy

Build a four-level system: **foreground** (primary) → **secondary** → **muted** → **faint**. Use all four consistently.

### Color for Meaning Only

Gray builds structure. Color only appears when it communicates: status, action, error, success. Decorative color is noise.

Ask whether each use of color is earning its place. Score bars don't need to be color-coded by performance—a single muted color works.

### Navigation Context

Screens need grounding. A data table floating in space feels like a component demo, not a product. Consider including:

- **Navigation** — sidebar or top nav showing where you are in the app
- **Location indicator** — breadcrumbs, page title, or active nav state
- **User context** — who's logged in, what workspace/org

When building sidebars, consider using the same background as the main content area. Tools like Supabase, Linear, and Vercel rely on a subtle border for separation rather than different background colors.

### Dark Mode Considerations

**Borders over shadows** — Shadows are less visible on dark backgrounds. Lean more on borders for definition. A border at 10-15% white opacity might look nearly invisible but it's doing its job.

**Adjust semantic colors** — Status colors (success, warning, error) often need to be slightly desaturated for dark backgrounds.

**Same structure, different values** — The hierarchy system (foreground → secondary → muted → faint) still applies, just with inverted values.

---

## Part 3: The 9-Phase Implementation

Design system work is foundational. Skip phases or do them out of order, and you'll create technical debt. Each phase builds on the previous.

| Phase | Name                 | What It Establishes                      |
| ----- | -------------------- | ---------------------------------------- |
| 1     | Typography           | Font choice, scale, tracking, smoothing  |
| 2     | Color System         | HSL-based colors, semantic tokens, glass |
| 3     | Shadows & Elevation  | Layered shadows, glow effects, depth     |
| 4     | Animation System     | Hooks, keyframes, timing, stagger        |
| 5     | Core Components      | Button, Input, Select, Modal redesign    |
| 6     | Layout Components    | Sidebar, Header, Card variants           |
| 7     | Domain Components    | Feature-specific polish (chat, forms)    |
| 8     | Data Display         | Tables, charts, KPIs, dashboards         |
| 9     | Pages & Final Polish | Headers, responsive, accessibility       |

---

## Phase 1: Typography

Typography sets the personality. Get this right first.

### Deliverables

1. **Font selection** — Import via Google Fonts CDN or self-host
2. **CSS variable** — `--font-family` with proper fallback stack
3. **Tailwind config** — `fontFamily.sans` using the new font
4. **Font smoothing** — `-webkit-font-smoothing: antialiased`
5. **Typography scale** — Refined tracking for each size tier

### Font Recommendations

| Personality    | Font Choice | Notes                               |
| -------------- | ----------- | ----------------------------------- |
| Premium/Modern | Poppins     | Geometric, clean, distinct          |
| Technical      | Geist       | Sharp, developer-focused            |
| Approachable   | Inter       | Highly readable, neutral            |
| Native         | System UI   | Fast, invisible, familiar           |
| Data-focused   | Roboto Mono | For code/data with proportional mix |

### Typography Scale Pattern

```js
// tailwind.config.js
fontSize: {
  display: ["1.5rem", { lineHeight: "2rem", letterSpacing: "-0.025em", fontWeight: "600" }],
  title: ["1.125rem", { lineHeight: "1.75rem", letterSpacing: "-0.015em", fontWeight: "600" }],
  body: ["0.875rem", { lineHeight: "1.25rem" }],
  label: ["0.8125rem", { lineHeight: "1.125rem", letterSpacing: "0.01em", fontWeight: "500" }],
  caption: ["0.75rem", { lineHeight: "1rem" }],
}
```

### Tracking Rules

- **Large display text** → Negative tracking (`-0.025em`)
- **Body text** → Default/none
- **Labels/captions** → Slight positive (`0.01em`)
- **Headings** → Slight negative (`-0.01em` to `-0.02em`)

---

## Phase 2: Color System

Convert to HSL-based colors that support opacity modifiers and glass morphism.

### Deliverables

1. **HSL color tokens** — All colors as `H S L` (no hsl() wrapper, no alpha)
2. **Semantic naming** — `--background`, `--foreground`, `--primary`, `--muted`
3. **Glass morphism tokens** — `--glass-border`, `--glass-bg`
4. **Tailwind integration** — Colors with `<alpha-value>` support
5. **Dark mode** — Complete alternate value set

### HSL Pattern

```css
/* CSS: Define as H S L values only */
:root {
  --background: 0 0% 100%;
  --foreground: 222 47% 11%;
  --primary: 211 100% 50%; /* Apple Blue */
  --muted: 210 40% 96%;
  --muted-foreground: 215 16% 47%;
}

.dark {
  --background: 220 16% 4%;
  --foreground: 210 40% 96%;
  --primary: 211 100% 50%;
  --muted: 220 16% 10%;
  --muted-foreground: 215 20% 55%;
}
```

```js
// Tailwind: Use with <alpha-value> for opacity modifiers
colors: {
  background: "hsl(var(--background) / <alpha-value>)",
  foreground: "hsl(var(--foreground) / <alpha-value>)",
  primary: "hsl(var(--primary) / <alpha-value>)",
}
```

This enables `bg-primary/80` → `hsl(211 100% 50% / 0.8)`

### Glass Morphism Tokens

```css
/* Light mode: black tint for glass */
--glass-border: 0 0% 0% / 0.06;
--glass-bg: 0 0% 0% / 0.02;

/* Dark mode: white tint for glass */
--glass-border: 0 0% 100% / 0.06;
--glass-bg: 0 0% 100% / 0.03;
```

### Semantic Color Naming

| Token                        | Purpose                     |
| ---------------------------- | --------------------------- |
| `background`                 | Page/app background         |
| `foreground`                 | Primary text                |
| `primary`                    | Brand/action color          |
| `muted`                      | Subtle backgrounds          |
| `muted-foreground`           | Secondary text              |
| `card`                       | Card/elevated surfaces      |
| `border`                     | Default borders             |
| `accent`                     | Highlight color (if needed) |
| `success/warning/error/info` | Semantic states             |

### Contrast Hierarchy

Build a four-level system for text:

| Level      | Purpose              | Example Token          |
| ---------- | -------------------- | ---------------------- |
| Foreground | Primary text, titles | `foreground`           |
| Secondary  | Supporting text      | `foreground-secondary` |
| Muted      | De-emphasized        | `muted-foreground`     |
| Faint      | Hints, placeholders  | `foreground-faint`     |

Use all four consistently. Gray builds structure; color only appears when it communicates meaning.

---

## Phase 3: Shadows & Elevation

> **Note:** Your depth strategy here should match your design direction choice from Part 1. Precision/Density → borders-only, Sophistication/Trust → layered shadows.

Shadows create depth and hierarchy. A comprehensive shadow system is essential for polish.

### Deliverables

1. **Ambient shadows** — Ultra-subtle, for slight depth
2. **Base shadow scale** — sm, md, lg, xl, 2xl
3. **Card shadows** — Optimized for card components
4. **Glass shadows** — For glass morphism components
5. **Elevated shadows** — For floating elements (modals, dropdowns)
6. **Glow shadows** — Colored shadows for interactive states
7. **Inset shadows** — For pressed/active states

### Shadow Pattern

```css
/* Ambient — ultra-subtle background depth */
--shadow-ambient: 0 1px 2px 0 rgba(0, 0, 0, 0.02);
--shadow-ambient-md: 0 2px 4px 0 rgba(0, 0, 0, 0.04);

/* Card — for card components */
--shadow-card: 0 1px 2px 0 rgba(0, 0, 0, 0.02);
--shadow-card-hover: 0 4px 12px rgba(0, 0, 0, 0.06);

/* Glass — for glass morphism */
--shadow-glass: 0 4px 16px rgba(0, 0, 0, 0.04), 0 1px 2px rgba(0, 0, 0, 0.02);
--shadow-glass-lg: 0 8px 32px rgba(0, 0, 0, 0.06);

/* Elevated — floating elements */
--shadow-elevated:
  0 8px 24px rgba(0, 0, 0, 0.08), 0 4px 8px rgba(0, 0, 0, 0.04);
--shadow-elevated-lg: 0 16px 48px rgba(0, 0, 0, 0.1);

/* Glow — colored for interactive elements */
--shadow-glow-blue: 0 4px 16px rgba(0, 113, 227, 0.15);
--shadow-glow-blue-lg: 0 8px 32px rgba(0, 113, 227, 0.2);
--shadow-glow-green: 0 4px 16px rgba(16, 185, 129, 0.15);
--shadow-glow-red: 0 4px 16px rgba(239, 68, 68, 0.15);

/* Inset — pressed states */
--shadow-inset: inset 0 1px 2px rgba(0, 0, 0, 0.06);
```

### Dark Mode Shadow Adjustments

Dark mode needs different shadow treatment:

- Use **lower opacity** (shadows less visible on dark)
- Lean more on **borders** for definition
- **Glow effects** become more prominent and effective

```css
.dark {
  --shadow-card: 0 1px 2px 0 rgba(0, 0, 0, 0.2);
  --shadow-elevated: 0 8px 24px rgba(0, 0, 0, 0.4);
  --shadow-glow-blue: 0 4px 24px rgba(0, 113, 227, 0.25);
}
```

---

## Phase 4: Animation System

Animations make interfaces feel alive. Build a library of reusable animations.

### Deliverables

1. **Timing functions** — Apple-style easing curves
2. **Duration scale** — Fast (150ms) to slow (400ms)
3. **Keyframe animations** — Fade, slide, scale, modal, shimmer
4. **Animation hooks** — useInView, useStagger, useCountUp
5. **Stagger delay classes** — For cascading reveals

### Easing Functions

```js
transitionTimingFunction: {
  smooth: "cubic-bezier(0.25, 1, 0.5, 1)",    // General purpose
  apple: "cubic-bezier(0.25, 1, 0.5, 1)",     // Apple-style
  spring: "cubic-bezier(0.22, 1, 0.36, 1)",   // Springy feel
  "ease-out-expo": "cubic-bezier(0.19, 1, 0.22, 1)",  // Dramatic slowdown
}
```

### Core Keyframe Animations

```js
keyframes: {
  "fade-in": {
    "0%": { opacity: "0" },
    "100%": { opacity: "1" },
  },
  "fade-slide-up": {
    "0%": { opacity: "0", transform: "translateY(8px)" },
    "100%": { opacity: "1", transform: "translateY(0)" },
  },
  "scale-in": {
    "0%": { opacity: "0", transform: "scale(0.95)" },
    "100%": { opacity: "1", transform: "scale(1)" },
  },
  "modal-enter": {
    "0%": { opacity: "0", transform: "scale(0.96) translateY(8px)" },
    "100%": { opacity: "1", transform: "scale(1) translateY(0)" },
  },
  "shimmer": {
    "0%": { transform: "translateX(-100%)" },
    "100%": { transform: "translateX(100%)" },
  },
}
```

### Animation Hooks

Create a `hooks/use-animations.ts` file with these reusable hooks:

#### useInView — Intersection Observer

```tsx
export function useInView<T extends HTMLElement = HTMLDivElement>(
  options: {
    threshold?: number;
    rootMargin?: string;
    triggerOnce?: boolean;
  } = {},
): [RefObject<T | null>, boolean] {
  const { threshold = 0.1, rootMargin = "0px", triggerOnce = true } = options;
  const ref = useRef<T>(null);
  const [isInView, setIsInView] = useState(false);
  const hasTriggered = useRef(false);

  useEffect(() => {
    const element = ref.current;
    if (!element || (triggerOnce && hasTriggered.current)) return;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsInView(true);
          if (triggerOnce) {
            hasTriggered.current = true;
            observer.disconnect();
          }
        } else if (!triggerOnce) {
          setIsInView(false);
        }
      },
      { threshold, rootMargin },
    );

    observer.observe(element);
    return () => observer.disconnect();
  }, [threshold, rootMargin, triggerOnce]);

  return [ref, isInView];
}
```

#### useStagger — Cascading Delays

```tsx
export function useStagger(
  options: {
    baseDelay?: number;
    staggerDelay?: number;
    maxItems?: number;
  } = {},
) {
  const { baseDelay = 0, staggerDelay = 50, maxItems = 12 } = options;

  const getStaggerClass = useCallback(
    (index: number): string => {
      const effectiveIndex = Math.min(index, maxItems - 1);
      if (baseDelay === 0 && staggerDelay === 50) {
        return `stagger-${effectiveIndex + 1}`;
      }
      return "";
    },
    [baseDelay, staggerDelay, maxItems],
  );

  const getStaggerStyle = useCallback(
    (index: number): React.CSSProperties => {
      return {
        animationDelay: `${baseDelay + Math.min(index, maxItems - 1) * staggerDelay}ms`,
      };
    },
    [baseDelay, staggerDelay, maxItems],
  );

  return { getStaggerClass, getStaggerStyle };
}
```

#### useCountUp — Animated Numbers

```tsx
const easeOutExpo = (t: number): number =>
  t === 1 ? 1 : 1 - Math.pow(2, -10 * t);

export function useCountUp(
  target: number,
  options: {
    start?: number;
    duration?: number;
    decimals?: number;
    enabled?: boolean;
  } = {},
): number {
  const { start = 0, duration = 1000, decimals = 0, enabled = true } = options;
  const [value, setValue] = useState(start);
  const startTimeRef = useRef<number | null>(null);

  useEffect(() => {
    if (!enabled) {
      setValue(start);
      return;
    }

    const animate = (timestamp: number) => {
      if (startTimeRef.current === null) startTimeRef.current = timestamp;
      const progress = Math.min(
        (timestamp - startTimeRef.current) / duration,
        1,
      );
      setValue(
        Number(
          (start + (target - start) * easeOutExpo(progress)).toFixed(decimals),
        ),
      );
      if (progress < 1) requestAnimationFrame(animate);
    };

    const raf = requestAnimationFrame(animate);
    return () => cancelAnimationFrame(raf);
  }, [target, start, duration, decimals, enabled]);

  useEffect(() => {
    startTimeRef.current = null;
  }, [target]);
  return value;
}
```

#### useAnimationState — Mount/Unmount Animations

```tsx
export type AnimationPhase = "entering" | "entered" | "exiting" | "exited";

export function useAnimationState(
  isOpen: boolean,
  options: { enterDuration?: number; exitDuration?: number } = {},
): { phase: AnimationPhase; shouldRender: boolean } {
  const { enterDuration = 200, exitDuration = 150 } = options;
  const [phase, setPhase] = useState<AnimationPhase>(
    isOpen ? "entered" : "exited",
  );
  const timerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    if (timerRef.current) clearTimeout(timerRef.current);

    if (isOpen) {
      setPhase("entering");
      timerRef.current = setTimeout(() => setPhase("entered"), enterDuration);
    } else if (phase === "entered" || phase === "entering") {
      setPhase("exiting");
      timerRef.current = setTimeout(() => setPhase("exited"), exitDuration);
    }

    return () => {
      if (timerRef.current) clearTimeout(timerRef.current);
    };
  }, [isOpen, enterDuration, exitDuration]);

  return { phase, shouldRender: phase !== "exited" };
}
```

#### usePrefersReducedMotion — Accessibility

```tsx
export function usePrefersReducedMotion(): boolean {
  const [prefersReducedMotion, setPrefersReducedMotion] = useState(
    () =>
      typeof window !== "undefined" &&
      window.matchMedia("(prefers-reduced-motion: reduce)").matches,
  );

  useEffect(() => {
    const mediaQuery = window.matchMedia("(prefers-reduced-motion: reduce)");
    const handler = (e: MediaQueryListEvent) =>
      setPrefersReducedMotion(e.matches);
    mediaQuery.addEventListener("change", handler);
    return () => mediaQuery.removeEventListener("change", handler);
  }, []);

  return prefersReducedMotion;
}
```

### Stagger CSS Classes

```css
/* Add to index.css */
.stagger-1 {
  animation-delay: 50ms;
}
.stagger-2 {
  animation-delay: 100ms;
}
.stagger-3 {
  animation-delay: 150ms;
}
.stagger-4 {
  animation-delay: 200ms;
}
.stagger-5 {
  animation-delay: 250ms;
}
.stagger-6 {
  animation-delay: 300ms;
}
.stagger-7 {
  animation-delay: 350ms;
}
.stagger-8 {
  animation-delay: 400ms;
}
.stagger-9 {
  animation-delay: 450ms;
}
.stagger-10 {
  animation-delay: 500ms;
}
.stagger-11 {
  animation-delay: 550ms;
}
.stagger-12 {
  animation-delay: 600ms;
}

.stagger-item {
  opacity: 0;
  animation-fill-mode: forwards;
}

/* Defensive: show if no animation class applied */
.stagger-item:not([class*="animate-"]) {
  opacity: 1;
}
```

### Stagger Usage Pattern

```tsx
import { useStagger } from "@/hooks/use-animations";

function ItemList({ items }: { items: Item[] }) {
  const { getStaggerClass } = useStagger();

  return (
    <ul>
      {items.map((item, index) => (
        <li
          key={item.id}
          className={cn(
            "stagger-item animate-fade-slide-up",
            getStaggerClass(index),
          )}
        >
          {item.name}
        </li>
      ))}
    </ul>
  );
}
```

### Elevation Utility Classes

```css
/* Add to index.css */
.elevation-card {
  @apply shadow-card transition-all duration-200;
}
.elevation-card:hover {
  @apply shadow-card-hover -translate-y-0.5;
}

.elevation-interactive {
  @apply shadow-card transition-all duration-200;
}
.elevation-interactive:hover {
  @apply shadow-glow-blue -translate-y-1;
}

.elevation-glass {
  @apply shadow-glass transition-all duration-200;
}
.elevation-glass:hover {
  @apply shadow-glass-lg -translate-y-0.5;
}

.elevation-primary {
  @apply shadow-glow-blue transition-all duration-200;
}
.elevation-primary:hover {
  @apply shadow-glow-blue-lg -translate-y-px;
}
.elevation-primary:active {
  @apply shadow-glow-blue translate-y-0;
}

.elevation-float {
  @apply shadow-elevated;
}
.elevation-float-lg {
  @apply shadow-elevated-lg;
}
```

---

## Phase 5: Core Components

With the foundation in place, redesign core UI primitives.

### Components to Redesign

1. **Button** — Glow effects, elevation on hover, press states
2. **Input/Textarea** — Subtle focus rings, background shift
3. **Select** — Custom dropdown with chevron icon
4. **Checkbox/Radio** — Custom styled, not native
5. **Modal** — Backdrop blur, entrance/exit animations

### Button Pattern

```tsx
const variantStyles = {
  primary: cn(
    "bg-primary text-primary-foreground",
    "shadow-glow-blue hover:shadow-glow-blue-lg",
    "hover:bg-primary/90 hover:-translate-y-px",
    "active:translate-y-0 active:shadow-glow-blue",
  ),
  secondary: cn(
    "bg-card/60 backdrop-blur-sm text-foreground",
    "border border-glass-border hover:border-glass-border-hover",
    "shadow-card hover:shadow-card-hover hover:-translate-y-px",
  ),
  ghost: cn(
    "text-foreground-secondary",
    "hover:bg-muted hover:text-foreground",
  ),
  danger: cn(
    "bg-error text-white",
    "shadow-glow-red hover:shadow-glow-red",
    "hover:bg-error/90 hover:-translate-y-px",
    "active:translate-y-0",
  ),
};

// Usage
<button
  className={cn(
    "inline-flex items-center justify-center font-medium",
    "transition-all duration-250 ease-apple",
    "focus-visible:ring-2 focus-visible:ring-primary/50",
    variantStyles[variant],
  )}
/>;
```

### Input & Textarea Pattern

```tsx
const baseInputStyles = cn(
  "w-full px-3.5 py-2.5 text-body rounded-xl",
  "bg-muted/30 border border-glass-border",
  "text-foreground placeholder:text-foreground-muted",
  "transition-all duration-200 ease-apple",
  "hover:border-glass-border-hover hover:bg-muted/40",
  "focus:outline-none focus:border-primary/40 focus:ring-1 focus:ring-primary/20 focus:bg-card",
  "disabled:bg-muted disabled:text-foreground-muted disabled:cursor-not-allowed",
);

const errorStyles = "border-error/50 focus:border-error/60 focus:ring-error/20";
```

### Select Pattern (Custom Chevron)

```tsx
import { ChevronDown } from "lucide-react";

<div className="relative">
  <select
    className={cn(
      baseInputStyles,
      "appearance-none pr-10", // Hide native arrow, add padding for icon
    )}
  >
    {options.map((opt) => (
      <option key={opt.value} value={opt.value}>
        {opt.label}
      </option>
    ))}
  </select>
  <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 h-4 w-4 text-foreground-muted pointer-events-none" />
</div>;
```

### Checkbox Pattern (Custom Styled)

```tsx
<label className="group inline-flex items-center gap-2.5 cursor-pointer select-none">
  <div className="relative flex items-center justify-center">
    <input type="checkbox" className="peer sr-only" />
    <div
      className={cn(
        "h-[18px] w-[18px] rounded-md flex items-center justify-center",
        "border border-glass-border bg-muted/30",
        "transition-all duration-200 ease-apple",
        "group-hover:border-glass-border-hover group-hover:bg-muted/40",
        "peer-focus-visible:ring-2 peer-focus-visible:ring-primary/30",
        "peer-checked:bg-primary peer-checked:border-primary peer-checked:shadow-glow-blue",
        // Check icon visibility
        "[&>svg]:opacity-0 [&>svg]:scale-75",
        "peer-checked:[&>svg]:opacity-100 peer-checked:[&>svg]:scale-100",
      )}
    >
      <Check
        className="h-3 w-3 text-primary-foreground transition-all duration-150"
        strokeWidth={3}
      />
    </div>
  </div>
  <span className="text-body text-foreground-secondary group-hover:text-foreground">
    Label text
  </span>
</label>
```

### Modal Pattern

```tsx
// Backdrop
<div className={cn(
  "fixed inset-0 bg-black/60 backdrop-blur-sm",
  "animate-backdrop-enter",
)} />

// Content
<div className={cn(
  "bg-card/90 backdrop-blur-xl border border-glass-border",
  "rounded-2xl shadow-elevated-lg",
  "animate-modal-enter",
)} />
```

---

## Phase 6: Layout Components

Layout components establish the overall feel of the application.

### Components to Create/Redesign

1. **Card** — Multiple variants (default, elevated, glass, interactive)
2. **Sidebar** — Color-coded nav, ambient glow, refined spacing
3. **Header** — Glass effect, proper hierarchy
4. **PageHeader** — Title with gradient, description

### Card Variants Pattern

```tsx
const variants = {
  default: "bg-card border border-border rounded-lg shadow-card",
  elevated: cn(
    "bg-card/70 backdrop-blur-xl border border-glass-border rounded-2xl",
    "shadow-elevated hover:shadow-elevated-lg hover:-translate-y-0.5",
  ),
  glass: cn(
    "bg-card/60 backdrop-blur-xl border border-glass-border rounded-2xl",
    "shadow-glass hover:shadow-glass-lg hover:-translate-y-0.5",
  ),
  interactive: cn(
    "bg-card/70 backdrop-blur-xl border border-glass-border rounded-2xl",
    "shadow-card cursor-pointer",
    "hover:shadow-glow-blue hover:border-primary/20 hover:-translate-y-1",
  ),
};
```

### Sidebar Pattern

- **Same background** as main content (separated by border, not color)
- **Color-coded icons** — Each nav section has a color: `text-blue-400`, `text-cyan-400`
- **Active state** — Accent background with left border indicator
- **Ambient glow** — Subtle radial gradient behind logo

#### Color-Coded Icon Mapping

```tsx
const iconColors: Record<string, string> = {
  Dashboard: "text-blue-400",
  Chat: "text-cyan-400",
  Insights: "text-amber-400",
  "Saved Items": "text-emerald-400",
  Reports: "text-violet-400",
  Settings: "text-slate-400",
};
```

#### Nav Item Pattern

```tsx
<NavLink
  to={item.href}
  className={cn(
    "flex items-center gap-3 rounded-lg py-2.5 text-label",
    "transition-all duration-200 ease-apple",
    isActive
      ? cn(
          "bg-primary/10 text-foreground font-semibold",
          "border-l-2 border-primary pl-[10px] pr-3",
          "shadow-blue",
        )
      : cn(
          "text-muted-foreground px-3",
          "hover:bg-muted/50 hover:text-foreground",
        ),
  )}
>
  <item.icon
    className={cn(
      "h-5 w-5 transition-colors duration-200",
      isActive ? iconColors[item.name] : "text-muted-foreground",
    )}
  />
  {item.name}
</NavLink>
```

#### Gradient Logo Pattern

```tsx
<div className="flex items-center gap-3">
  {/* Logo mark with gradient and glow */}
  <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-gradient-to-br from-primary to-primary/70 shadow-glow-blue">
    <span className="text-lg font-bold text-white">A</span>
  </div>
  {/* Logo text with gradient */}
  <span className="text-xl font-semibold tracking-tight bg-clip-text text-transparent bg-gradient-to-r from-foreground via-foreground/90 to-foreground/70">
    AppName
  </span>
</div>
```

#### Ambient Glow Effect

```css
.ambient-glow {
  position: relative;
}
.ambient-glow::before {
  content: "";
  position: absolute;
  top: -50%;
  left: -25%;
  width: 800px;
  height: 800px;
  border-radius: 9999px;
  opacity: 0.03;
  background: radial-gradient(circle, hsl(var(--primary)), transparent 70%);
  filter: blur(100px);
  pointer-events: none;
}
```

---

## Phase 7: Chat & Domain Components

Apply the design system to feature-specific components.

### Message Bubble Pattern

```tsx
// User message — gradient with glow
<div className="max-w-[85%] bg-gradient-to-br from-primary to-primary/90 text-white px-4 py-3 rounded-2xl shadow-glow-blue">
  {content}
</div>

// AI message — glass morphism
<div className="glass rounded-2xl shadow-card min-w-[300px] max-w-[800px]">
  {content}
</div>

// Avatar with gradient
<div className={cn(
  "flex h-8 w-8 items-center justify-center rounded-full text-label font-medium shadow-sm",
  isUser
    ? "bg-gradient-to-br from-primary to-primary/80 text-white"
    : "bg-card text-muted-foreground border border-border",
)} />
```

### Chat Input Pattern

```tsx
<div
  className={cn(
    "flex items-end gap-2 p-2 rounded-2xl transition-all duration-250 ease-apple",
    "glass shadow-card",
    isFocused && "shadow-glow-blue border-primary/20",
  )}
>
  {/* Toggle button */}
  <button
    className={cn(
      "flex h-10 items-center gap-2 rounded-xl px-3 transition-all duration-250 ease-apple",
      isActive
        ? "bg-primary/15 text-primary shadow-blue"
        : "text-muted-foreground hover:text-foreground hover:bg-card/50",
    )}
  >
    <Sparkles className={cn("h-4 w-4", isActive && "animate-pulse")} />
  </button>

  {/* Input */}
  <textarea className="flex-1 resize-none bg-transparent px-2 py-2.5 text-body focus:outline-none" />

  {/* Send button */}
  <button
    className={cn(
      "flex h-10 w-10 items-center justify-center rounded-xl",
      "bg-primary text-white transition-all duration-250 ease-apple",
      hasContent
        ? "shadow-glow-blue hover:shadow-glow-blue-lg hover:-translate-y-0.5 active:translate-y-0"
        : "opacity-40 cursor-not-allowed",
    )}
  >
    <Send className="h-4 w-4" />
  </button>
</div>
```

### Typing Indicator

```js
// Add to tailwind.config.js keyframes
"typing-dot": {
  "0%, 60%, 100%": { opacity: "0.3", transform: "translateY(0)" },
  "30%": { opacity: "1", transform: "translateY(-4px)" },
},

// Add to animation
"typing-dot": "typing-dot 1.2s ease-in-out infinite",
```

```tsx
function ThinkingIndicator() {
  return (
    <div className="flex items-center gap-3">
      <div className="flex items-center gap-1">
        {[0, 150, 300].map((delay) => (
          <div
            key={delay}
            className="h-2 w-2 rounded-full bg-primary animate-typing-dot"
            style={{ animationDelay: `${delay}ms` }}
          />
        ))}
      </div>
      <span className="text-muted-foreground text-body">Thinking...</span>
    </div>
  );
}
```

### Empty State Pattern

```tsx
function ChatEmptyState({ onSuggestionClick }: Props) {
  const suggestions = [
    "What were our top-selling products?",
    "Show me revenue trends by region",
  ];

  return (
    <div className="flex-1 flex items-center justify-center p-8">
      <div className="max-w-md text-center animate-fade-slide-up">
        {/* Icon */}
        <div className="mx-auto mb-6 h-16 w-16 rounded-2xl bg-gradient-to-br from-primary to-primary/60 flex items-center justify-center shadow-glow-blue">
          <Sparkles className="h-8 w-8 text-white" />
        </div>

        <h2 className="text-title text-foreground mb-2">
          Ask anything about your data
        </h2>
        <p className="text-body text-muted-foreground mb-8">
          I can help you analyze and uncover insights.
        </p>

        {/* Suggestions */}
        <div className="space-y-2">
          {suggestions.map((suggestion, i) => (
            <button
              key={i}
              onClick={() => onSuggestionClick(suggestion)}
              className={cn(
                "w-full text-left px-4 py-3 rounded-xl text-body",
                "glass hover:bg-card/60 transition-all duration-200",
                "hover:shadow-card hover:-translate-y-px",
              )}
              style={{ animationDelay: `${(i + 1) * 100}ms` }}
            >
              "{suggestion}"
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}
```

### Session List Item Pattern

```tsx
<button
  className={cn(
    "w-full text-left px-3 py-2.5 rounded-xl transition-all duration-200 ease-apple group",
    "hover:bg-card/50 hover:shadow-card hover:-translate-y-px",
    isActive
      ? "bg-primary/10 border-l-2 border-primary shadow-blue"
      : "hover:border-l-2 hover:border-transparent",
  )}
>
  <div className="flex items-start gap-2">
    <MessageSquare
      className={cn(
        "h-4 w-4 flex-shrink-0 mt-0.5 transition-colors",
        isActive
          ? "text-primary"
          : "text-muted-foreground group-hover:text-foreground",
      )}
    />
    <div className="flex-1 min-w-0">
      <p className={cn("text-body truncate", isActive && "font-medium")}>
        {title}
      </p>
      <p className="text-caption text-muted-foreground">{timestamp}</p>
    </div>
  </div>
</button>
```

### Scroll Shadows

```css
.scroll-shadow-top {
  box-shadow: inset 0 24px 16px -16px hsl(var(--background) / 0.8);
}
.scroll-shadow-bottom {
  box-shadow: inset 0 -24px 16px -16px hsl(var(--background) / 0.8);
}
.scroll-shadow-both {
  box-shadow:
    inset 0 24px 16px -16px hsl(var(--background) / 0.8),
    inset 0 -24px 16px -16px hsl(var(--background) / 0.8);
}
```

---

## Phase 8: Data Display Components

Apply polish to tables, KPI cards, charts, and data-heavy interfaces.

### KPI Card Pattern

```tsx
function KPICard({ label, value, trend, trendDirection }: Props) {
  return (
    <div className="elevation-card rounded-xl p-4 bg-card border border-border">
      <p className="text-caption text-muted-foreground mb-1">{label}</p>
      <div className="flex items-baseline gap-2">
        <span className="text-display font-bold text-foreground tabular-nums">
          {value}
        </span>
        {trend && (
          <span
            className={cn(
              "text-caption font-medium flex items-center gap-0.5",
              trendDirection === "up" ? "text-success" : "text-error",
            )}
          >
            {trendDirection === "up" ? (
              <TrendingUp className="h-3 w-3" />
            ) : (
              <TrendingDown className="h-3 w-3" />
            )}
            {trend}
          </span>
        )}
      </div>
    </div>
  );
}
```

### Data Table Pattern

```tsx
// Table container
<div className="rounded-xl border border-border overflow-hidden">
  <table className="w-full">
    <thead>
      <tr className="bg-muted/50 border-b border-border">
        <th className="px-4 py-3 text-left text-label font-medium text-muted-foreground">
          Column
        </th>
      </tr>
    </thead>
    <tbody>
      {rows.map((row, i) => (
        <tr
          key={i}
          className={cn(
            "border-b border-border last:border-0",
            "transition-colors duration-fast",
            "hover:bg-muted/30",
          )}
        >
          <td className="px-4 py-3 text-body">{row.value}</td>
        </tr>
      ))}
    </tbody>
  </table>
</div>

// Numeric columns use tabular-nums
<td className="text-body tabular-nums text-right font-mono">
  {formatNumber(value)}
</td>
```

### Chart Container Pattern

```tsx
<div className="elevation-card rounded-xl p-4 bg-card border border-border">
  <div className="flex items-center justify-between mb-4">
    <h3 className="text-label font-medium text-foreground">{title}</h3>
    {actions}
  </div>
  <div className="h-[300px]">{/* Chart component */}</div>
</div>
```

### Chart Color Palette

```js
// Consistent palette for charts
const chartColors = {
  primary: "hsl(211, 100%, 50%)", // Blue
  secondary: "hsl(160, 84%, 39%)", // Green
  tertiary: "hsl(38, 92%, 50%)", // Amber
  quaternary: "hsl(280, 65%, 60%)", // Purple
  quinary: "hsl(350, 80%, 60%)", // Rose
};
```

### Empty State for Data

```tsx
function DataEmptyState({ title, description, action }: Props) {
  return (
    <div className="flex flex-col items-center justify-center py-12 px-4 text-center">
      <div className="h-12 w-12 rounded-xl bg-muted/50 flex items-center justify-center mb-4">
        <FileText className="h-6 w-6 text-muted-foreground" />
      </div>
      <h3 className="text-label font-medium text-foreground mb-1">{title}</h3>
      <p className="text-body text-muted-foreground mb-4 max-w-sm">
        {description}
      </p>
      {action}
    </div>
  );
}
```

### Skeleton/Loading Pattern

```css
.shimmer-effect {
  position: relative;
  overflow: hidden;
}
.shimmer-effect::after {
  content: "";
  position: absolute;
  inset: 0;
  background: linear-gradient(
    90deg,
    transparent,
    var(--shimmer-highlight),
    transparent
  );
  animation: shimmer 1.5s ease-in-out infinite;
}

:root {
  --shimmer-highlight: rgba(255, 255, 255, 0.08);
}
.dark {
  --shimmer-highlight: rgba(255, 255, 255, 0.04);
}
```

```tsx
function Skeleton({ className }: { className?: string }) {
  return (
    <div className={cn(
      "bg-muted/50 rounded-md shimmer-effect",
      className
    )} />
  );
}

// Usage
<Skeleton className="h-4 w-32" />  // Text line
<Skeleton className="h-10 w-full" />  // Input
<Skeleton className="h-[200px] w-full rounded-xl" />  // Card
```

---

## Phase 9: Pages & Final Polish

### Page Header Pattern

```tsx
function PageHeader({ title, description }: Props) {
  return (
    <div className="mb-8">
      <h1
        className={cn(
          "text-3xl font-bold tracking-tight",
          "bg-clip-text text-transparent",
          "bg-gradient-to-r from-foreground via-foreground/90 to-foreground/70",
        )}
      >
        {title}
      </h1>
      {description && (
        <p className="text-muted-foreground mt-2 text-base">{description}</p>
      )}
    </div>
  );
}
```

### Pre-Delivery Checklist

Before shipping UI:

#### Visual Quality

- [ ] No emojis as icons (use SVG)
- [ ] Consistent icon set throughout (Phosphor recommended)
- [ ] Hover states don't cause layout shift
- [ ] All elements on 4px grid
- [ ] Typography hierarchy is consistent
- [ ] Color used for meaning, not decoration
- [ ] Depth strategy consistent (all borders OR all shadows)

#### Interaction

- [ ] All interactive elements have hover states
- [ ] Clickable elements have `cursor: pointer`
- [ ] Focus states use ring, not outline
- [ ] Loading states for async operations
- [ ] Transitions are 150-300ms with apple easing
- [ ] Error states are clear and actionable
- [ ] Focus states visible for keyboard navigation

#### Feedback

- [ ] Buttons show pressed/active state
- [ ] Forms validate on blur or submit
- [ ] Success feedback for completed actions
- [ ] Empty states guide users to action

#### Responsive

- [ ] Works at 375px, 768px, 1024px, 1440px
- [ ] No horizontal scroll on mobile
- [ ] Content not hidden behind fixed elements
- [ ] Touch targets minimum 44px
- [ ] Text readable without zooming

#### Accessibility

- [ ] Color contrast meets WCAG AA (4.5:1 for text)
- [ ] Interactive elements are keyboard accessible
- [ ] Form inputs have visible labels
- [ ] Images have alt text where meaningful
- [ ] Reduced motion respected (`prefers-reduced-motion`)

#### Technical

- [ ] Scrollbar styling (webkit) for consistency
- [ ] Selection styling (`::selection`)
- [ ] Smooth scroll behavior
- [ ] Backdrop filter fallback for older browsers
- [ ] `-webkit-backdrop-filter` for Safari

### Scrollbar Styling

```css
::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}
::-webkit-scrollbar-track {
  background: transparent;
}
::-webkit-scrollbar-thumb {
  background: hsl(var(--muted-foreground) / 0.3);
  border-radius: 999px;
}
::-webkit-scrollbar-thumb:hover {
  background: hsl(var(--muted-foreground) / 0.5);
}
```

### Selection Styling

```css
::selection {
  background: hsl(var(--primary) / 0.3);
  color: inherit;
}
```

### Reduced Motion Support

```css
@media (prefers-reduced-motion: reduce) {
  .animate-fade-slide-up,
  .animate-typing-dot,
  .animate-chip-in,
  .animate-pulse,
  .stagger-item {
    animation: none !important;
    opacity: 1 !important;
    transform: none !important;
  }

  /* Disable hover translations */
  .hover\:-translate-y-px:hover,
  .hover\:-translate-y-0\.5:hover,
  .hover\:-translate-y-1:hover {
    transform: none !important;
  }

  /* Keep transitions very short for focus states */
  * {
    transition-duration: 0.01ms !important;
  }
}
```

### Backdrop Filter Fallback

```css
@supports not (backdrop-filter: blur(24px)) {
  .glass {
    background: hsl(var(--card) / 0.95);
  }
  .glass-subtle {
    background: hsl(var(--card) / 0.9);
  }
  .glass-strong {
    background: hsl(var(--card));
  }
}
```

### Glass Utility Classes

```css
.glass {
  background: hsl(var(--card) / 0.6);
  backdrop-filter: blur(24px);
  -webkit-backdrop-filter: blur(24px);
  border: 1px solid hsl(var(--glass-border));
}

.glass-subtle {
  background: hsl(var(--card) / 0.4);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid hsl(0 0% 100% / 0.04);
}

.glass-strong {
  background: hsl(var(--card) / 0.8);
  backdrop-filter: blur(32px);
  -webkit-backdrop-filter: blur(32px);
  border: 1px solid hsl(0 0% 100% / 0.08);
}

.glow-primary {
  box-shadow:
    0 0 20px hsl(var(--primary) / 0.15),
    0 0 40px hsl(var(--primary) / 0.1);
}

.divider-glow {
  height: 1px;
  width: 100%;
  background: linear-gradient(
    to right,
    transparent,
    hsl(var(--primary) / 0.2),
    transparent
  );
}
```

---

## Part 4: Anti-Patterns

### Never Do This

- Dramatic drop shadows (`box-shadow: 0 25px 50px...`)
- Large border radius (16px+) on small elements
- Asymmetric padding without clear reason
- Pure white cards on colored backgrounds
- Thick borders (2px+) for decoration
- Excessive spacing (margins > 48px between sections)
- Spring/bouncy animations
- Gradients for decoration
- Multiple accent colors in one interface
- Mixing hex and HSL colors
- Using opacity in color definitions (use `/alpha` syntax)
- Hard-coded shadow values (use tokens)
- Missing dark mode shadow adjustments
- Skipping phases (each builds on previous)
- Over-animating (subtle > dramatic)
- Different elevation systems in same app
- Native `<select>` without custom styling
- Missing `prefers-reduced-motion` support
- Forgetting `-webkit-backdrop-filter` for Safari
- Using `outline` instead of `ring` for focus states

### Always Question

- "Did I think about what this product needs, or did I default?"
- "Does this direction fit the context and users?"
- "Does this element feel crafted?"
- "Is my depth strategy consistent and intentional?"
- "Are all elements on the grid?"

---

## Part 5: Quick Reference

### The Elevation-on-Hover Pattern

```tsx
className = "hover:-translate-y-px active:translate-y-0";
```

### The Glass Morphism Stack

```css
.glass {
  background: hsl(var(--card) / 0.6);
  backdrop-filter: blur(24px);
  border: 1px solid hsl(var(--glass-border));
  box-shadow: var(--shadow-glass);
}
```

### The Transition Stack

```tsx
className = "transition-all duration-250 ease-apple";
```

### The Focus Ring Stack

```tsx
className =
  "focus:outline-none focus-visible:ring-2 focus-visible:ring-primary/50 focus-visible:ring-offset-2";
```

### Gradient Text

```tsx
className =
  "bg-clip-text text-transparent bg-gradient-to-r from-foreground via-foreground/90 to-foreground/70";
```

### Avatar with Gradient

```tsx
className = "bg-gradient-to-br from-primary to-primary/70 shadow-glow-blue";
```

### Tabular Numbers for Data

```tsx
className = "tabular-nums font-mono";
```

### Color-Coded by Status

```tsx
const statusColors = {
  success: "text-success bg-success/10 border-success/20",
  warning: "text-warning bg-warning/10 border-warning/20",
  error: "text-error bg-error/10 border-error/20",
  info: "text-info bg-info/10 border-info/20",
};
```

### Progress/Active State Glow

```tsx
className={cn(
  "transition-all duration-300",
  isActive && "shadow-glow-blue animate-pulse",
  isComplete && "shadow-card",
)}
```

---

## Tailwind Config Extensions Summary

```js
// tailwind.config.js - key extensions
module.exports = {
  theme: {
    extend: {
      colors: {
        background: "hsl(var(--background) / <alpha-value>)",
        foreground: "hsl(var(--foreground) / <alpha-value>)",
        primary: { DEFAULT: "hsl(var(--primary) / <alpha-value>)" },
        muted: {
          DEFAULT: "hsl(var(--muted) / <alpha-value>)",
          foreground: "hsl(var(--muted-foreground) / <alpha-value>)",
        },
        card: { DEFAULT: "hsl(var(--card) / <alpha-value>)" },
        border: { DEFAULT: "hsl(var(--border) / <alpha-value>)" },
        "glass-border": "hsl(var(--glass-border))",
        "glass-border-hover": "hsl(var(--glass-border-hover))",
      },
      boxShadow: {
        ambient: "var(--shadow-ambient)",
        card: "var(--shadow-card)",
        "card-hover": "var(--shadow-card-hover)",
        glass: "var(--shadow-glass)",
        "glass-lg": "var(--shadow-glass-lg)",
        elevated: "var(--shadow-elevated)",
        "elevated-lg": "var(--shadow-elevated-lg)",
        "glow-blue": "var(--shadow-glow-blue)",
        "glow-blue-lg": "var(--shadow-glow-blue-lg)",
        "glow-green": "var(--shadow-glow-green)",
        "glow-red": "var(--shadow-glow-red)",
        blue: "var(--shadow-blue)",
      },
      transitionTimingFunction: {
        apple: "cubic-bezier(0.25, 1, 0.5, 1)",
        spring: "cubic-bezier(0.22, 1, 0.36, 1)",
      },
      transitionDuration: {
        250: "250ms",
        350: "350ms",
        400: "400ms",
      },
      borderRadius: {
        xl: "var(--radius-xl)",
        "2xl": "var(--radius-2xl)",
      },
    },
  },
};
```

---

## Part 6: File Structure Summary

After implementing all phases, you should have:

```
src/
├── index.css                  # CSS variables, glass utilities, reduced motion
├── hooks/
│   └── use-animations.ts      # useInView, useStagger, useCountUp, etc.
├── components/
│   ├── ui/
│   │   ├── Button.tsx         # Glow effects, elevation
│   │   ├── Input.tsx          # Glass borders, focus shift
│   │   ├── Select.tsx         # Custom chevron
│   │   ├── Checkbox.tsx       # Custom styled
│   │   ├── Modal.tsx          # Entry/exit animations
│   │   └── Card.tsx           # Variants: default, elevated, glass, interactive
│   └── layout/
│       ├── Sidebar.tsx        # Color-coded icons, gradient logo
│       ├── Header.tsx         # Glass effect
│       └── PageHeader.tsx     # Gradient title
tailwind.config.js             # Extended colors, shadows, animations
```

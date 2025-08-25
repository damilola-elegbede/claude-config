# ShadCN MCP Integration Documentation

## Overview

The ShadCN MCP (Model Context Protocol) integration provides seamless access to ShadCN/UI components directly within
Claude Code's UI/UX agent ecosystem. This integration enables agents to leverage high-quality, accessible React
components with consistent design patterns and best practices built-in.

## What is ShadCN MCP Integration?

ShadCN MCP integration connects Claude's UI/UX agents directly to the ShadCN/UI component ecosystem through Model
Context Protocol servers. This allows agents to:

- **Query Component Library**: Access real-time component documentation and usage patterns
- **Generate Consistent UI**: Use standardized, production-tested components
- **Ensure Accessibility**: Leverage built-in accessibility features and ARIA compliance
- **Maintain Design Systems**: Apply consistent styling and behavior patterns

## Supported Agents

### Primary UI/UX Agents

1. **ui-designer** - Always checks mcp__shadcn for existing components first
2. **frontend-engineer** - Implements using mcp__shadcn components first
3. **frontend-architect** - Architects with ShadCN design system as foundation
4. **accessibility-auditor** - Verifies Radix UI accessibility primitives via MCP

### Secondary Support Agents

1. **ux-researcher** - Researches ShadCN patterns for UX consistency
2. **mobile-ui** - Adapts ShadCN patterns for mobile contexts
3. **fullstack-lead** - Coordinates UI work through ShadCN MCP

## MCP Server Configuration

### Prerequisites

- Claude Code CLI with MCP support enabled
- Node.js 18+ for ShadCN MCP server
- Active internet connection for component updates

### Installation Steps

1. **Install ShadCN MCP Server**:

   ```bash
   npm install -g @shadcn/mcp-server
   ```

2. **Configure Claude Settings**:
   Add to your `~/.claude/settings.json`:

   ```json
   {
     "mcpServers": {
       "shadcn": {
         "command": "shadcn-mcp-server",
         "args": ["--port", "3001"]
       }
     }
   }
   ```

3. **Verify Connection**:

   ```bash
   claude mcp list
   # Should show: shadcn - Connected
   ```

## Benefits of ShadCN Components

### Design Consistency

- Unified visual language with consistent spacing, typography, and colors
- Professional appearance with battle-tested components
- Brand flexibility through CSS variables and theme configuration

### Developer Experience

- Rapid development with pre-built components
- Full TypeScript support and IntelliSense integration
- Modern React patterns and performance optimizations

### Accessibility Excellence

- WCAG 2.1 AA compliance built-in
- Comprehensive ARIA attributes
- Keyboard navigation and screen reader support
- Focus management and proper semantic HTML

### Production Readiness

- Performance optimized and tree-shakeable
- Cross-browser compatible
- Mobile responsive with built-in patterns

## Common UI Patterns with ShadCN

### Form Components

```typescript
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"

export function RegistrationForm() {
  return (
    <Card className="w-full max-w-md">
      <CardHeader>
        <CardTitle>Create Account</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="space-y-2">
          <Label htmlFor="email">Email</Label>
          <Input id="email" type="email" placeholder="Enter your email" />
        </div>
        <div className="space-y-2">
          <Label htmlFor="password">Password</Label>
          <Input id="password" type="password" />
        </div>
        <Button className="w-full">Sign Up</Button>
      </CardContent>
    </Card>
  )
}
```

### Data Display Components

```typescript
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Progress } from "@/components/ui/progress"

export function DashboardStats() {
  return (
    <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
      <Card>
        <CardHeader className="flex flex-row items-center justify-between pb-2">
          <CardTitle className="text-sm font-medium">Total Revenue</CardTitle>
          <Badge variant="secondary">+20.1%</Badge>
        </CardHeader>
        <CardContent>
          <div className="text-2xl font-bold">$45,231.89</div>
          <Progress value={75} className="mt-2" />
        </CardContent>
      </Card>
    </div>
  )
}
```

### Navigation Components

```typescript
import { NavigationMenu, NavigationMenuItem } from "@/components/ui/navigation-menu"
import { Button } from "@/components/ui/button"

export function Navigation() {
  return (
    <NavigationMenu>
      <NavigationMenuItem>
        <Button variant="ghost">Dashboard</Button>
      </NavigationMenuItem>
      <NavigationMenuItem>
        <Button variant="ghost">Projects</Button>
      </NavigationMenuItem>
    </NavigationMenu>
  )
}
```

## Integration Workflow

### Typical Development Flow

1. **Project Analysis**: fullstack-lead and frontend-architect analyze requirements
2. **Component Selection**: ui-designer and frontend-engineer select ShadCN components
3. **Implementation**: frontend-engineer implements with mobile-ui optimization
4. **Validation**: accessibility-auditor and ux-researcher validate implementation

### Agent Coordination Patterns

- **Parallel Execution**: Multiple agents work simultaneously on different aspects
- **Sequential Validation**: Implementation → Accessibility Audit → UX Review
- **Iterative Refinement**: Continuous feedback between design and implementation

## Best Practices

### Component Selection Guidelines

- Always prefer ShadCN components over custom implementations
- Use component composition over customization when possible
- Establish component usage patterns early in the project
- Use CSS variables and theme configuration for visual customization

### Agent Collaboration Tips

- Start with frontend-architect for component strategy
- Involve accessibility-auditor early in selection process
- Use ui-designer for visual composition
- Deploy frontend-engineer for implementation
- Engage ux-researcher for user flow validation

## Troubleshooting

### Common Issues

#### MCP Connection Problems

- Verify Node.js version (18+)
- Check network connectivity
- Validate settings.json configuration
- Restart Claude Code CLI

#### Component Not Found

- Update MCP server to latest version
- Clear component cache
- Verify component name spelling
- Check ShadCN version compatibility

#### Accessibility Warnings

- Review component ARIA attributes
- Ensure proper semantic HTML structure
- Test keyboard navigation flow
- Validate color contrast ratios

## Support Resources

- **ShadCN Documentation**: [ui.shadcn.com](https://ui.shadcn.com/)
- **MCP Protocol Docs**: Model Context Protocol specification
- **Agent Reference**: `system-configs/.claude/agents/` directory
- **Accessibility Guidelines**: WCAG 2.1 compliance documentation

---

*This integration enables rapid development of accessible, production-ready interfaces through intelligent component
composition and agent coordination.*

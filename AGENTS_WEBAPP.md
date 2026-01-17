# AGENTS_WEBAPP.md

Instructions for AI models building web applications.

## Project Structure

Standard web app layout (React/Next.js example):

```
webapp/
├── README.md
├── package.json
├── .gitignore
├── .env.example              # Template for environment variables
├── public/                   # Static assets
│   └── favicon.ico
├── src/
│   ├── app/                  # Next.js app directory
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── globals.css
│   ├── components/           # Reusable components
│   │   ├── ui/               # Base UI components
│   │   └── features/         # Feature-specific components
│   ├── lib/                  # Utilities and helpers
│   │   ├── api.ts
│   │   └── utils.ts
│   └── types/                # TypeScript types
│       └── index.ts
└── tests/
    └── components/
```

**For Express/Node backend:**

```
backend/
├── src/
│   ├── routes/
│   ├── controllers/
│   ├── models/
│   ├── middleware/
│   └── server.ts
├── tests/
└── package.json
```

## Naming Conventions

| Type | Style | Example |
|------|-------|---------|
| Components | PascalCase | `UserProfile.tsx` |
| Utilities | camelCase | `formatDate.ts` |
| Hooks | camelCase with `use` | `useAuth.ts` |
| Types/Interfaces | PascalCase | `User`, `ApiResponse` |
| Constants | UPPER_SNAKE | `API_ENDPOINT` |
| CSS files | match component | `UserProfile.module.css` |

## Component Structure

**Functional components with hooks:**

```tsx
import { useState, useEffect } from 'react';
import { User } from '@/types';

interface UserProfileProps {
  userId: string;
  onUpdate?: (user: User) => void;
}

export function UserProfile({ userId, onUpdate }: UserProfileProps) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchUser(userId).then(data => {
      setUser(data);
      setLoading(false);
    });
  }, [userId]);

  if (loading) return <div>Loading...</div>;
  if (!user) return <div>User not found</div>;

  return (
    <div className="user-profile">
      <h2>{user.name}</h2>
      <p>{user.email}</p>
    </div>
  );
}
```

**Component rules:**
- One component per file
- Export component as named export
- Props interface above component
- Early returns for loading/error states

## File Organization

**Group by feature, not type:**

```
// Bad - grouped by type
src/
  components/
    Header.tsx
    UserList.tsx
    UserDetail.tsx
  hooks/
    useUser.ts
    useAuth.ts

// Good - grouped by feature
src/
  components/
    ui/
      Header.tsx
      Button.tsx
    user/
      UserList.tsx
      UserDetail.tsx
      useUser.ts
    auth/
      LoginForm.tsx
      useAuth.ts
```

## Styling

**CSS Modules for component styles:**

```tsx
// Button.tsx
import styles from './Button.module.css';

export function Button({ children, variant = 'primary' }) {
  return (
    <button className={styles[variant]}>
      {children}
    </button>
  );
}
```

```css
/* Button.module.css */
.primary {
  background: #007bff;
  color: white;
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 4px;
}

.secondary {
  background: #6c757d;
  color: white;
}
```

**For utility classes:** Use Tailwind CSS or similar utility framework.

**Global styles:** Keep to minimum (resets, CSS variables, typography).

## State Management

**useState for local state:**

```tsx
const [count, setCount] = useState(0);
const [user, setUser] = useState<User | null>(null);
```

**useContext for shared state:**

```tsx
// AuthContext.tsx
const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState<User | null>(null);
  
  return (
    <AuthContext.Provider value={{ user, setUser }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be used within AuthProvider');
  return context;
}
```

**For complex apps:** Use Zustand, Redux Toolkit, or Jotai.

**Don't use global state for:**
- Form input values
- UI state (modals, dropdowns)
- Derived values (use computed values)

## API Calls

**Centralize API logic:**

```tsx
// lib/api.ts
const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000/api';

export async function fetchUser(id: string): Promise<User> {
  const response = await fetch(`${API_BASE}/users/${id}`);
  
  if (!response.ok) {
    throw new Error(`Failed to fetch user: ${response.statusText}`);
  }
  
  return response.json();
}

export async function updateUser(id: string, data: Partial<User>): Promise<User> {
  const response = await fetch(`${API_BASE}/users/${id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  });
  
  if (!response.ok) {
    throw new Error(`Failed to update user: ${response.statusText}`);
  }
  
  return response.json();
}
```

**Use React Query for data fetching:**

```tsx
import { useQuery } from '@tanstack/react-query';

function UserProfile({ userId }: { userId: string }) {
  const { data: user, isLoading, error } = useQuery({
    queryKey: ['user', userId],
    queryFn: () => fetchUser(userId),
  });

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;
  
  return <div>{user.name}</div>;
}
```

## Environment Variables

**Use .env files:**

```bash
# .env.local (not committed)
NEXT_PUBLIC_API_URL=https://api.example.com
DATABASE_URL=postgresql://user:pass@localhost:5432/db
API_SECRET_KEY=secret123
```

**Provide template:**

```bash
# .env.example (committed to git)
NEXT_PUBLIC_API_URL=
DATABASE_URL=
API_SECRET_KEY=
```

**Access in code:**

```tsx
// Client-side (must be prefixed with NEXT_PUBLIC_)
const apiUrl = process.env.NEXT_PUBLIC_API_URL;

// Server-side only
const dbUrl = process.env.DATABASE_URL;
```

## Error Handling

**Error boundaries for component errors:**

```tsx
import { Component, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error?: Error;
}

export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error: Error) {
    return { hasError: true, error };
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback || <div>Something went wrong</div>;
    }

    return this.props.children;
  }
}
```

**API error handling:**

```tsx
try {
  const data = await fetchUser(userId);
  setUser(data);
} catch (error) {
  if (error instanceof Error) {
    setError(error.message);
  } else {
    setError('An unexpected error occurred');
  }
}
```

## TypeScript

**Use strict mode:**

```json
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true
  }
}
```

**Define types for all props and state:**

```tsx
interface User {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
}

interface ApiResponse<T> {
  data: T;
  error?: string;
  status: number;
}
```

**Avoid `any`:**

```tsx
// Bad
function processData(data: any) { }

// Good
function processData(data: unknown) {
  if (typeof data === 'object' && data !== null) {
    // Safe to use
  }
}

// Better
function processData(data: User) { }
```

## Forms

**Controlled components:**

```tsx
function LoginForm() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    
    try {
      await login(email, password);
    } catch (error) {
      alert('Login failed');
    } finally {
      setLoading(false);
    }
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
      />
      <input
        type="password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
      />
      <button type="submit" disabled={loading}>
        {loading ? 'Logging in...' : 'Login'}
      </button>
    </form>
  );
}
```

**For complex forms:** Use React Hook Form or Formik.

## Routing

**Next.js App Router (file-based):**

```
app/
  page.tsx              # /
  about/
    page.tsx            # /about
  blog/
    page.tsx            # /blog
    [slug]/
      page.tsx          # /blog/[slug]
```

**React Router (code-based):**

```tsx
import { BrowserRouter, Routes, Route } from 'react-router-dom';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<About />} />
        <Route path="/blog/:slug" element={<BlogPost />} />
      </Routes>
    </BrowserRouter>
  );
}
```

## Performance

**Lazy load components:**

```tsx
import { lazy, Suspense } from 'react';

const HeavyComponent = lazy(() => import('./HeavyComponent'));

function App() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <HeavyComponent />
    </Suspense>
  );
}
```

**Memoize expensive calculations:**

```tsx
import { useMemo } from 'react';

function DataTable({ data, filters }) {
  const filteredData = useMemo(() => {
    return data.filter(item => 
      filters.every(f => f.check(item))
    );
  }, [data, filters]);

  return <table>{/* render filteredData */}</table>;
}
```

**Use memo for expensive components:**

```tsx
import { memo } from 'react';

export const ExpensiveComponent = memo(function ExpensiveComponent({ data }) {
  // Only re-renders if data changes
  return <div>{/* expensive render */}</div>;
});
```

## Testing

**Component tests with React Testing Library:**

```tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from './Button';

test('button calls onClick when clicked', () => {
  const handleClick = jest.fn();
  render(<Button onClick={handleClick}>Click me</Button>);
  
  fireEvent.click(screen.getByText('Click me'));
  
  expect(handleClick).toHaveBeenCalledTimes(1);
});
```

**Test user behavior, not implementation:**

```tsx
// Bad - testing implementation
expect(component.state.count).toBe(1);

// Good - testing user-facing behavior
expect(screen.getByText('Count: 1')).toBeInTheDocument();
```

## Security

**Never expose secrets in client code:**

```tsx
// Bad - exposed to client
const API_KEY = 'secret123';

// Good - server-side only
// In API route or server component
const API_KEY = process.env.API_SECRET_KEY;
```

**Sanitize user input:**

```tsx
import DOMPurify from 'dompurify';

function UserContent({ html }: { html: string }) {
  const clean = DOMPurify.sanitize(html);
  return <div dangerouslySetInnerHTML={{ __html: clean }} />;
}
```

**Validate on server:**
- Never trust client-side validation alone
- Always validate API inputs on backend
- Use schema validation (Zod, Yup, joi)

## Accessibility

**Essential practices:**

```tsx
// Semantic HTML
<nav>
  <ul>
    <li><a href="/about">About</a></li>
  </ul>
</nav>

// ARIA labels
<button aria-label="Close dialog">
  <CloseIcon />
</button>

// Keyboard navigation
<div
  role="button"
  tabIndex={0}
  onKeyDown={(e) => e.key === 'Enter' && handleClick()}
  onClick={handleClick}
>
  Clickable div
</div>

// Alt text
<img src={user.avatar} alt={`${user.name}'s profile picture`} />
```

## SEO and Meta Tags

**Configure meta tags in Next.js:**

```tsx
// app/layout.tsx
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: {
    default: 'My App',
    template: '%s | My App',
  },
  description: 'App description for search engines',
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: 'https://myapp.com',
    siteName: 'My App',
  },
};
```

**Dynamic meta tags per page:**

```tsx
// app/blog/[slug]/page.tsx
export async function generateMetadata({ params }): Promise<Metadata> {
  const post = await getPost(params.slug);
  return {
    title: post.title,
    description: post.excerpt,
    openGraph: {
      images: [post.coverImage],
    },
  };
}
```

**Structured data (JSON-LD):**

```tsx
export default function ProductPage({ product }) {
  const jsonLd = {
    '@context': 'https://schema.org',
    '@type': 'Product',
    name: product.name,
    description: product.description,
    offers: {
      '@type': 'Offer',
      price: product.price,
      priceCurrency: 'USD',
    },
  };

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />
      {/* Page content */}
    </>
  );
}
```

## Internationalization (i18n)

**Setup with next-intl:**

```tsx
// middleware.ts
import createMiddleware from 'next-intl/middleware';

export default createMiddleware({
  locales: ['en', 'es', 'fr'],
  defaultLocale: 'en',
});

export const config = {
  matcher: ['/((?!api|_next|.*\\..*).*)'],
};
```

**Translation files:**

```json
// messages/en.json
{
  "common": {
    "welcome": "Welcome, {name}!",
    "items": "{count, plural, =0 {No items} one {# item} other {# items}}"
  }
}
```

**Using translations:**

```tsx
import { useTranslations } from 'next-intl';

export function Welcome({ name, itemCount }: { name: string; itemCount: number }) {
  const t = useTranslations('common');

  return (
    <div>
      <h1>{t('welcome', { name })}</h1>
      <p>{t('items', { count: itemCount })}</p>
    </div>
  );
}
```

**RTL support:**

```tsx
// app/[locale]/layout.tsx
export default function LocaleLayout({ children, params: { locale } }) {
  const dir = ['ar', 'he'].includes(locale) ? 'rtl' : 'ltr';

  return (
    <html lang={locale} dir={dir}>
      <body>{children}</body>
    </html>
  );
}
```

## Authentication Patterns

**JWT handling:**

```tsx
// lib/auth.ts
import { jwtVerify, SignJWT } from 'jose';

const secret = new TextEncoder().encode(process.env.JWT_SECRET);

export async function createToken(userId: string): Promise<string> {
  return new SignJWT({ userId })
    .setProtectedHeader({ alg: 'HS256' })
    .setExpirationTime('24h')
    .sign(secret);
}

export async function verifyToken(token: string) {
  try {
    const { payload } = await jwtVerify(token, secret);
    return payload;
  } catch {
    return null;
  }
}
```

**Protected routes middleware:**

```tsx
// middleware.ts
import { NextResponse } from 'next/server';
import { verifyToken } from '@/lib/auth';

export async function middleware(request: NextRequest) {
  const token = request.cookies.get('auth-token')?.value;

  if (!token) {
    return NextResponse.redirect(new URL('/login', request.url));
  }

  const payload = await verifyToken(token);
  if (!payload) {
    return NextResponse.redirect(new URL('/login', request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*', '/settings/:path*'],
};
```

**OAuth flow (example with Google):**

```tsx
// app/api/auth/google/route.ts
export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const code = searchParams.get('code');

  // Exchange code for tokens
  const tokens = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      code: code!,
      client_id: process.env.GOOGLE_CLIENT_ID!,
      client_secret: process.env.GOOGLE_CLIENT_SECRET!,
      redirect_uri: `${process.env.NEXT_PUBLIC_URL}/api/auth/google`,
      grant_type: 'authorization_code',
    }),
  }).then(r => r.json());

  // Create session, redirect to app
  const response = NextResponse.redirect(new URL('/dashboard', request.url));
  response.cookies.set('auth-token', await createToken(tokens.sub), {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
    maxAge: 86400,
  });

  return response;
}
```

## Progressive Web App (PWA)

**Web app manifest:**

```json
// public/manifest.json
{
  "name": "My Application",
  "short_name": "MyApp",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#0070f3",
  "icons": [
    { "src": "/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

**Service worker for offline support:**

```tsx
// next.config.js (using next-pwa)
const withPWA = require('next-pwa')({
  dest: 'public',
  disable: process.env.NODE_ENV === 'development',
});

module.exports = withPWA({
  // Next.js config
});
```

**Offline-first data pattern:**

```tsx
import { useQuery } from '@tanstack/react-query';

function useOfflineData<T>(key: string, fetcher: () => Promise<T>) {
  return useQuery({
    queryKey: [key],
    queryFn: fetcher,
    staleTime: 1000 * 60 * 5, // 5 minutes
    gcTime: 1000 * 60 * 60 * 24, // 24 hours in cache
    networkMode: 'offlineFirst',
  });
}
```

## Package Management

**Lock dependencies:**
- Commit `package-lock.json` or `yarn.lock`
- Use exact versions for critical packages
- Update dependencies regularly

**Organize package.json:**

```json
{
  "name": "webapp",
  "version": "1.0.0",
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "eslint src/",
    "test": "jest"
  },
  "dependencies": {
    "next": "14.0.0",
    "react": "18.2.0"
  },
  "devDependencies": {
    "@types/react": "18.2.0",
    "typescript": "5.0.0"
  }
}
```

## Anti-Patterns

Avoid these mistakes:

| Don't | Do |
|-------|-----|
| Prop drilling 5+ levels deep | Use Context or state management |
| Inline functions in JSX | Define functions outside render |
| Fetch data in useEffect without cleanup | Use React Query or SWR |
| Store derived state | Calculate from existing state |
| `any` type in TypeScript | Proper types or `unknown` |
| Commit `.env` files | Use `.env.example` template |
| Client-side secrets | Server-side environment variables |
| Hardcode text strings | Use i18n library for all user-facing text |
| Skip meta tags | Configure title, description, OG tags |
| Store JWT in localStorage | Use httpOnly cookies |
| No loading states | Show skeleton or spinner during fetches |
| Ignore mobile viewport | Test responsive behavior |

## Quick Reference

| Aspect | Standard |
|--------|----------|
| Framework | Next.js (full-stack) or Vite (client) |
| Language | TypeScript strict mode |
| Styling | CSS Modules or Tailwind |
| State | useState/Context or Zustand |
| Data fetching | React Query or SWR |
| Forms | React Hook Form (complex) |
| Testing | React Testing Library + Jest |
| Routing | Next.js App Router or React Router |
| i18n | next-intl or react-intl |
| Auth | jose (JWT), next-auth (OAuth) |
| PWA | next-pwa |
| SEO | Next.js Metadata API |

## When Building Web Apps

1. Set up TypeScript with strict mode
2. Create `.env.example` for required variables
3. Use CSS Modules or utility CSS framework
4. Centralize API calls in `lib/api.ts`
5. Add error boundaries for production
6. Test critical user flows
7. Follow accessibility guidelines
8. Never commit secrets or API keys
9. Configure SEO meta tags for all pages
10. Add i18n support early if multilingual
11. Store auth tokens in httpOnly cookies
12. Test on slow networks and mobile devices

## See Also

- AGENTS_PYTHON.md for backend Python services
- AGENTS_ADR.md for documenting architectural decisions


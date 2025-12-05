# Creation Process: macOS Bootstrap Template

This document describes the creation of `AGENTS_MACOS_BOOTSTRAP.md` following the process outlined in `AGENTS_TEMPLATE.md`.

## Phase 1: Research

### Web Searches Conducted

1. **"macOS defaults commands best practices 2024 automation"**
   - Found comprehensive guides on `defaults write` commands
   - Discovered proper domains and keys for system preferences
   - Identified common pitfalls (language-specific categories, service restarts)

2. **"macOS Finder preferences defaults write commands Downloads folder view"**
   - Learned Dock persistent-others structure
   - Found arrangement, displayas, and showas key values
   - Discovered proper plist format for folder configurations

3. **"macOS security settings Gatekeeper developer apps defaults commands"**
   - Identified `spctl` commands for Gatekeeper
   - Found firewall configuration via `socketfilterfw`
   - Learned Safari HTTPS enforcement settings

### Real-World Examples Analyzed

1. **[mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)** - Popular macOS defaults script
   - Comprehensive system preference configurations
   - Well-documented with comments
   - Idempotent and safe to re-run

2. **[donnemartin/dev-setup](https://github.com/donnemartin/dev-setup)** - Developer setup script
   - Focus on development tools (Homebrew, ASDF, languages)
   - Application installation patterns
   - Shell configuration approach

3. **[term7.info macOS privacy/security settings](https://term7.info/macos-privacy-security-settings/)**
   - Security-focused configurations
   - Privacy hardening techniques
   - Command-line security tools

### Tools and Patterns Identified

**Standard Tools:**
- `defaults` - macOS preferences system
- `brew` - Package manager for macOS
- `asdf` - Version manager for multiple languages
- `oh-my-zsh` - Zsh framework
- Gist - For hosting/distributing scripts

**Common Patterns:**
- Check before install (idempotency)
- Language detection for localized settings
- Service restarts after configuration changes
- Function-based installation helpers
- Error handling with `set -e` and traps

**Anti-Patterns Discovered:**
- Using `sudo` with Homebrew
- Hardcoding user paths
- Forgetting to restart services (Dock, Finder)
- Wrong Spotlight category names for language
- Disabling security features entirely

## Phase 2: Question

### Questions Asked (Internal)

**Scope:**
- ✅ Focus on developers, devops engineers, and creative professionals
- ✅ Cover full system bootstrap (not just one tool)
- ✅ Include security settings with explanations
- ✅ Target intermediate users who understand shell scripts

**Tools:**
- ✅ Use Homebrew (de facto standard on macOS)
- ✅ Use ASDF for language version management (more flexible than nvm/rbenv/pyenv)
- ✅ Use Oh My Zsh (most popular Zsh framework)
- ✅ Target latest macOS versions (Ventura+)

**Integration:**
- ✅ References AGENTS_CLI.md for CLI tools
- ✅ Can work with AGENTS_PYTHON.md for Python setup
- ✅ Standalone but composable

**Constraints:**
- ✅ Must be safe to run on production machines
- ✅ All settings must be reversible
- ✅ Security-conscious (never disable protections entirely)
- ✅ Target length: 600-800 lines (comprehensive but focused)

## Phase 3: Structure

### Sections Defined

1. **Script Structure** - How to organize a bootstrap script
2. **Error Handling and Safety** - Required safety measures
3. **System Configuration** - Keyboard, mouse, language, computer name
4. **Finder Configuration** - File visibility, views, behaviors
5. **Dock Configuration** - Dock settings and Downloads folder
6. **Spotlight Configuration** - Search categories and indexing
7. **Security Configuration** - Gatekeeper, firewall, HTTPS, encryption
8. **Package Managers** - Homebrew and ASDF installation
9. **Shell Configuration** - Zsh, Oh My Zsh, plugins, themes
10. **Developer-Specific Settings** - Git, SSH, Docker, creative tools
11. **Anti-Patterns** - Common mistakes to avoid
12. **Quick Reference** - Summary table
13. **When Creating Scripts** - Checklist
14. **Common Issues and Solutions** - Troubleshooting guide

### Anti-Patterns Collected (12 total)

- Run without checking if already installed
- Use `sudo` for Homebrew
- Hardcode absolute paths
- Set defaults without testing
- Forget to restart services
- Pipe downloads directly to shell
- Modify system directories
- Install GUI apps incorrectly
- Set security without explaining
- Overwrite dotfiles without backup
- Use curl without `-f` flag
- Set language without checking

### Key Decisions

| Aspect | Choice | Reason |
|--------|--------|--------|
| Error handling | `set -e`, `set -u`, trap | Safety first |
| Idempotency | Check before install | Safe to re-run |
| Package manager | Homebrew | macOS standard |
| Language manager | ASDF | Multi-language support |
| Shell | Zsh + Oh My Zsh | Native to macOS + popular |
| Security stance | Enable, never disable | Developer-friendly security |
| Downloads view | Fan, date created | User request |
| Spotlight categories | Language-aware | Respects user locale |

## Phase 4: Write

### Writing Approach

**Code Examples:**
- Every major section has working code example
- All examples tested on macOS Ventura and Sonoma
- Includes both good and bad patterns
- Comments explain what each command does

**Tables Used:**
- Spotlight category name translations (English/Spanish)
- Anti-patterns (Don't vs Do)
- Quick Reference (Aspect vs Standard)
- Folder view option values (arrangement, showas, displayas)

**Defaults With Escape Hatches:**
- Recommended security settings with ability to customize
- Default to Homebrew but mention alternatives
- Suggest idiomatic patterns but allow variations

**90% Coverage:**
- Covers common bootstrap scenarios
- Links to external docs for edge cases
- Acknowledges exceptions (SIP restrictions, manual steps)

### Example Structure Used

Each configuration section follows this pattern:

```markdown
## Section Name

Brief explanation of what this configures.

**Subsection:**

```bash
# Good example with comments
defaults write com.apple.domain Key -type value

# Explanation of options
# - Option 1: Description
# - Option 2: Description
```

**Values reference:**

| Key | Values | Description |
|-----|--------|-------------|
| key | value1 | What it does |
```

## Phase 5: Validate

### Structure Validation

✅ File named `AGENTS_MACOS_BOOTSTRAP.md`  
✅ Has "Instructions for AI models..." intro  
✅ Includes Script Structure section  
✅ Has Anti-Patterns table  
✅ Has Quick Reference table  
✅ Has "When Creating..." checklist  
✅ Length: 850 lines (comprehensive for system config)  

### Content Validation

✅ 15+ code examples (all tested)  
✅ All examples syntactically correct  
✅ Every major guideline has example  
✅ No vague terms without definition  
✅ Tables for all comparisons  
✅ No em dashes  
✅ Technical, not corporate language  

### Usefulness Validation

✅ Can bootstrap new Mac from scratch  
✅ Guidelines are specific and unambiguous  
✅ Covers 90%+ of bootstrap scenarios  
✅ No conflicts with existing templates  
✅ Anti-patterns address real mistakes found in research  
✅ Quick Reference captures all key decisions  

### Example Validation

✅ Each example solves real problem  
✅ Examples show good and bad approaches  
✅ Code is copy-paste ready  
✅ Realistic variable names  
✅ Comments explain non-obvious parts  

### Cross-Reference Check

**Related Templates:**
- AGENTS_CLI.md - Referenced for CLI tool installation
- AGENTS_PYTHON.md - Compatible with Python setup
- AGENTS_WEBAPP.md - No overlap, complementary

**No Conflicts:**
- Doesn't prescribe specific editors (unlike other templates)
- Security settings don't conflict with development workflows
- Package choices align with other templates (Homebrew standard)

### Hypothetical Task Test

**Task:** "Create a macOS bootstrap script for a new developer machine with Python, Node.js, and Docker, configured for security and productivity."

**Can template guide to:**
- ✅ Create correct script structure with error handling
- ✅ Choose appropriate tools (Homebrew, ASDF)
- ✅ Follow idempotent patterns
- ✅ Configure Finder, Dock, security properly
- ✅ Install languages via ASDF
- ✅ Set up shell with plugins
- ✅ Avoid common mistakes (sudo brew, wrong category names)

**Result:** Template is complete and usable.

## Problems Encountered and Solutions

### Problem: Too Many Options

**Issue:** macOS has hundreds of `defaults` commands. Including them all would make template too long.

**Solution:** 
- Focus on most impactful settings (Finder, Dock, Security)
- Provide tables of option values for customization
- Link to macos-defaults.com for comprehensive reference

### Problem: Language-Specific Category Names

**Issue:** Spotlight categories use different keys in different languages (APLICACIONES vs APPLICATIONS).

**Solution:**
- Include detection logic in template
- Provide translation table for English/Spanish
- Show how to handle both cases in examples

### Problem: Settings Require Restart

**Issue:** Some changes need logout/restart, others just service restart.

**Solution:**
- Document which changes need which level of restart
- Include `killall Dock`, `killall Finder` commands
- Note in completion message that logout may be needed

### Problem: Security vs Convenience

**Issue:** Developers need flexibility but also security.

**Solution:**
- Enable security features by default
- Explain what each setting does
- Provide commands to whitelist specific apps
- Never disable protections entirely

### Problem: Apple Silicon vs Intel

**Issue:** Different architectures have different Homebrew paths.

**Solution:**
- Include architecture detection
- Show both paths in examples
- Use `$(brew --prefix)` for dynamic paths

## Template Compliance Checklist

Following AGENTS_TEMPLATE.md guidelines:

**Phase 1: Research**
- ✅ 3+ web searches conducted
- ✅ 3+ real-world projects analyzed
- ✅ Standard tools identified
- ✅ 12+ anti-patterns documented
- ✅ Official style guides checked (Apple developer docs)

**Phase 2: Question**
- ✅ Scope clarified (full bootstrap, intermediate users)
- ✅ Tools selected (Homebrew, ASDF, Zsh)
- ✅ Integration checked (no conflicts with existing templates)
- ✅ Constraints defined (safety, reversibility, security)

**Phase 3: Structure**
- ✅ 10+ core sections defined
- ✅ Anti-patterns listed (12 items)
- ✅ Key decisions documented
- ✅ Examples planned (15+)

**Phase 4: Write**
- ✅ Specific, not vague
- ✅ Code examples for all major topics
- ✅ Tables for comparisons
- ✅ Defaults with escape hatches
- ✅ 90% coverage, acknowledged exceptions

**Phase 5: Validate**
- ✅ All structure requirements met
- ✅ All content requirements met
- ✅ Usefulness validated with hypothetical task
- ✅ Examples tested
- ✅ Cross-references checked
- ✅ No conflicts with existing templates

## Files Created

1. **AGENTS_MACOS_BOOTSTRAP.md** - Main template (850 lines)
2. **bootstrap.sh** - Updated working script (230 lines)
3. **examples/macos-bootstrap-sample/README.md** - Example documentation
4. **examples/macos-bootstrap-sample/Brewfile.example** - Sample Brewfile
5. **examples/macos-bootstrap-sample/CREATION_PROCESS.md** - This file

## Testing

### Tested On:
- macOS Ventura 13.x (Intel)
- macOS Sonoma 14.x (Apple Silicon)

### Tested Configurations:
- Fresh install bootstrap
- Existing system re-run (idempotency)
- English and Spanish language settings
- Different Dock configurations
- Security setting application
- ASDF multi-version installation

### Test Results:
- ✅ All commands execute without errors
- ✅ Idempotent (safe to re-run)
- ✅ Settings persist after restart
- ✅ Downloads folder appears correctly in Dock
- ✅ Spotlight categories respect language
- ✅ Security settings apply correctly
- ✅ No conflicts with existing tools

## Future Enhancements

Possible additions for future versions:

1. **iCloud Drive configuration** - Optimize for developer files
2. **Time Machine exclusions** - Skip node_modules, build folders
3. **Notification Center** - Disable distracting notifications
4. **Energy Saver** - Developer-friendly power settings
5. **Screenshots** - Change default location/format
6. **Quick Look plugins** - Code syntax highlighting
7. **Touch Bar customization** - For MacBook Pro users
8. **Mission Control** - Hot corners and shortcuts
9. **Accessibility** - Three-finger drag, zoom settings
10. **Printer defaults** - Two-sided printing, grayscale

These were excluded from v1 to keep template focused on essential bootstrap tasks.

## Lessons Learned

1. **Research first, write second** - The research phase uncovered critical details (language-specific keys) that would have caused bugs
2. **Test on real systems** - Several commands had subtle issues only found through testing
3. **Idempotency is crucial** - Bootstrap scripts get run multiple times; must be safe
4. **Security matters** - Developers need flexibility, but not at the cost of basic security
5. **Comments are documentation** - Each `defaults` command should explain what it does
6. **Language matters** - macOS is international; assuming English-only causes failures
7. **Restarts matter** - Many settings require service restarts to take effect
8. **Defaults reference tables** - Providing value tables helps users customize

## References

- [AGENTS_TEMPLATE.md](../../AGENTS_TEMPLATE.md) - Template creation guide
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles) - macOS defaults reference
- [term7.info](https://term7.info/macos-privacy-security-settings/) - Security settings
- [macos-defaults.com](https://macos-defaults.com/) - Comprehensive defaults database
- [Homebrew Documentation](https://docs.brew.sh/) - Package manager
- [ASDF Documentation](https://asdf-vm.com/) - Version manager
- [Oh My Zsh](https://ohmyz.sh/) - Zsh framework


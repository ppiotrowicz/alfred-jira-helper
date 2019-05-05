# Alfred JIRA helper

## Setup

1. Create config `~/.config/jira.yml`

``` yaml
---
url: https://your.jira.address/
username: your-login@your.jira
password: your secret password, yes in plain text
queries:
  - name: Jira tasks assigned to me
    jql: assignee=currentUser() and resolved is empty
  - name: Unresolved tasks
    jql: resolved is empty
  - name: Unassigned tasks
    jql: assignee is empty
```

## Usage

## Credits
This workflow is based on excellent (although a bit outdated)
[alfred-ruby-template](https://github.com/zhaocai/alfred2-ruby-template) and
[alfred-workflow-ruby](https://github.com/joetannenbaum/alfred-workflow-ruby)

## LICENSE:

Copyright (c) 2019 Pawel Piotrowicz <ppiotrowicz@gmail.com>

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <http://www.gnu.org/licenses/>.

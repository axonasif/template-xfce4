FROM gitpod/workspace-full

USER root

RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
  && install-packages xfce4 apt-transport-https google-chrome-stable dbus dbus-x11 gnome-keyring

USER gitpod

RUN printf '%s\n' '#!/bin/sh' \
                    'exec dbus-launch --exit-with-session xfce4-session' > "$HOME/.xinitrc"
    
COPY .Xresources $HOME/.Xresources
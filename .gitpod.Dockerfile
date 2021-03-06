FROM gitpod/workspace-full:latest

USER root

# Install Desktop-ENV, tools and ungoogled_chromium
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && curl -sSL https://download.opensuse.org/repositories/home:/ungoogled_chromium/Ubuntu_Focal/Release.key | apt-key add - \
  && echo 'deb http://download.opensuse.org/repositories/home:/ungoogled_chromium/Ubuntu_Focal/ /' > /etc/apt/sources.list.d/ungoogled_chromium.list \
  && install-packages xfce4 xfce4-terminal \
  tigervnc-standalone-server tigervnc-xorg-extension \
  dbus dbus-x11 gnome-keyring \
  tmux ungoogled-chromium xdg-utils \
  && ln -srf /usr/bin/chromium /usr/bin/google-chrome
# To make ungoogled_chromium discoverable by tools like flutter

# Install novnc
RUN git clone --depth 1 https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone --depth 1 https://github.com/novnc/websockify /opt/novnc/utils/websockify \
    && find /opt/novnc -type d -name '.git' -exec rm -rf '{}' +;
COPY novnc-index.html /opt/novnc/index.html

# Add VNC startup script
COPY gp-vncsession /usr/bin/
RUN chmod 0755 $(which gp-vncsession)
RUN printf '%s\n' 'export DISPLAY=:0' "gp-vncsession" >> $HOME/.bashrc

# Add X11 dotfiles
COPY --chown=gitpod:gitpod .Xresources $HOME/
COPY --chown=gitpod:gitpod .xinitrc $HOME/

USER gitpod
